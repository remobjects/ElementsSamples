namespace com.example.android.wiktionary;

{*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *}

interface

uses
  android.util,
  org.json,
  android.net,
  android.text,
  android.webkit,
  java.util,
  java.util.regex;

type
  /// <summary>
  /// Extended version of SimpleWikiHelper. This version adds methods to
  /// pick a random word, and to format generic wiki-style text into HTML.
  /// </summary>
  ExtendedWikiHelper = public class(SimpleWikiHelper)
  private
    // HTML style sheet to include with any formatWikiText(String) HTML
    // results. It formats nicely for a mobile screen, and hides some content
    // boxes to keep things tidy.
    const STYLE_SHEET = '<style>h2 {font-size:1.2em;font-weight:normal;} ' +
      'a {color:#6688cc;} ol {padding-left:1.5em;} blockquote {margin-left:0em;} ' +
      '.interProject, .noprint {display:none;} ' +
      'li, blockquote {margin-top:0.5em;margin-bottom:0.5em;}</style>';
    // Pattern of section titles we're interested in showing. This trims out
    // extra sections that can clutter things up on a mobile screen.
    class var sValidSections: Pattern := Pattern.compile('(verb|noun|adjective|pronoun|interjection)', Pattern.CASE_INSENSITIVE); readonly;
    // Pattern that can be used to split a returned wiki page into its various
    // sections. Doesn't treat children sections differently.
    class var sSectionSplit: Pattern := Pattern.compile('^=+(.+?)=+.+?(?=^=)', Pattern.MULTILINE or Pattern.DOTALL); readonly;
    // When picking random words in getRandomWord(), we sometimes
    // encounter special articles or templates. This pattern ignores any words
    // like those, usually because they have ":" or other punctuation.
    class var sInvalidWord: Pattern := Pattern.compile('[^A-Za-z0-9 ]'); readonly;
    // Uri to use when requesting a random page.
    const WIKTIONARY_RANDOM = 'http://en.wiktionary.org/w/api.php?action=query&list=random&format=json';
    // Fake section to insert at the bottom of a wiki response before parsing.
    // This ensures that sSectionSplit will always catch the last
    // section, as it uses section headers in its searching.
    const STUB_SECTION = ''#10'=Stub section=';
    // Number of times to try finding a random word in getRandomWord().
    // These failures are usually when the found word fails the
    // sInvalidWord test, or when a network error happens.
    const RANDOM_TRIES = 3;
    // List of internal formatting rules to apply when parsing wiki text. These
    // include indenting various bullets, apply italic and bold styles, and
    // adding internal linking.
    class var sFormatRules: List<FormatRule> := new ArrayList<FormatRule>(); readonly;
  public
    // Uri authority to use when creating internal links.
    const WIKI_AUTHORITY = 'wiktionary';
    // Uri host to use when creating internal links.
    const WIKI_LOOKUP_HOST = 'lookup';
    // Mime-type to use when showing parsed results in a WebView.
    const MIME_TYPE = 'text/html';
    // Encoding to use when showing parsed results in a WebView.
    const ENCODING = 'utf-8';
  public
    class constructor;
    class method getRandomWord: String;
    class method formatWikiText(wikiText: String): String;
  end;

  /// <summary>
  /// Internal class to hold a wiki formatting rule. It's mostly a wrapper to
  /// simplify Matcher.replaceAll(String).
  /// </summary>
  FormatRule nested in ExtendedWikiHelper = private class
  private
    var mPattern: Pattern;
    var mReplaceWith: String;
  public
    constructor(aPattern: String; replaceWith: String; &flags: Integer);
    constructor(aPattern: String; replaceWith: String);
    method apply(input: String): String;
  end;

implementation

class constructor ExtendedWikiHelper;
begin
  //  Format header blocks and wrap outside content in ordered list
  sFormatRules.add(new FormatRule("^=+(.+?)=+", "</ol><h2>$1</h2><ol>", Pattern.MULTILINE));
  //  Indent quoted blocks, handle ordered and bullet lists
  sFormatRules.add(new FormatRule("^#+\*?:(.+?)$", "<blockquote>$1</blockquote>", Pattern.MULTILINE));
  sFormatRules.add(new FormatRule("^#+:?\*(.+?)$", "<ul><li>$1</li></ul>", Pattern.MULTILINE));
  sFormatRules.add(new FormatRule("^#+(.+?)$", "<li>$1</li>", Pattern.MULTILINE));
  //  Add internal links
  sFormatRules.add(new FormatRule("\[\[([^:\|\]]+)\]\]", String.format('<a href="%s://%s/$1">$1</a>', WIKI_AUTHORITY, WIKI_LOOKUP_HOST)));
  sFormatRules.add(new FormatRule("\[\[([^:\|\]]+)\|([^\]]+)\]\]", String.format('<a href="%s://%s/$1">$2</a>', WIKI_AUTHORITY, WIKI_LOOKUP_HOST)));
  //  Add bold and italic formatting
  sFormatRules.add(new FormatRule("'''(.+?)'''", "<b>$1</b>"));
  sFormatRules.add(new FormatRule("([^'])''([^'].*?[^'])''([^'])", "$1<i>$2</i>$3"));
  //  Remove odd category links and convert remaining links into flat text
  sFormatRules.add(new FormatRule("(\{+.+?\}+|\[\[[^:]+:[^\\|\]]+\]\]|" +
    "\[http.+?\]|\[\[Category:.+?\]\])", "", Pattern.MULTILINE or Pattern.DOTALL));
  sFormatRules.add(new FormatRule("\[\[([^\|\]]+\|)?(.+?)\]\]", "$2", Pattern.MULTILINE));
end;

/// <summary>
/// Query the Wiktionary API to pick a random dictionary word. Will try
/// multiple times to find a valid word before giving up.
/// Throws ApiException If any connection or server error occurs.
/// Throws ParseException If there are problems parsing the response.
/// </summary>
/// <returns>Random dictionary word, or null if no valid word was found.</returns>
class method ExtendedWikiHelper.getRandomWord: String;
begin
  //  Keep trying a few times until we find a valid word
  for tries: Integer := 0 to pred(RANDOM_TRIES) do
  begin
    //  Query the API for a random word
    var content: String := getUrlContent(WIKTIONARY_RANDOM);
    try
      //  Drill into the JSON response to find the returned word
      var response: JSONObject := new JSONObject(content);
      var query: JSONObject := response.JSONObject['query'];
      var random: JSONArray := query.JSONArray['random'];
      var word: JSONObject := random.JSONObject[0];
      var foundWord: String := word.String['title'];
      //  If we found an actual word, and it wasn't rejected by our invalid
      //  filter, then accept and return it.
      if (foundWord <> nil) and not sInvalidWord.matcher(foundWord).find then
        exit foundWord;
    except
      on e: JSONException do 
        raise new ParseException('Problem parsing API response', e);
    end
  end;
  //  No valid word found in number of tries, so return nil
  exit nil
end;

/// <summary>
/// Format the given wiki-style text into formatted HTML content. This will
/// create headers, lists, internal links, and style formatting for any wiki
/// markup found.
/// </summary>
/// <param name="wikiText">The raw text to format, with wiki-markup included.</param>
/// <returns>HTML formatted content, ready for display in WebView.</returns>
class method ExtendedWikiHelper.formatWikiText(wikiText: String): String;
begin
  if wikiText = nil then
    exit nil;
  //  Insert a fake last section into the document so our section splitter
  //  can correctly catch the last section.
  wikiText := wikiText.concat(STUB_SECTION);
  //  Read through all sections, keeping only those matching our filter,
  //  and only including the first entry for each title.
  var foundSections: HashSet<String> := new HashSet<String>;
  var builder: StringBuilder := new StringBuilder;
  var sectionMatcher: Matcher := sSectionSplit.matcher(wikiText);
  while sectionMatcher.find do
  begin
    var title: String := sectionMatcher.group(1);
    if not foundSections.contains(title) and sValidSections.matcher(title).matches then
    begin
      var sectionContent: String := sectionMatcher.group;
      foundSections.&add(title);
      builder.append(sectionContent)
    end
  end;
  //  Our new wiki text is the selected sections only
  wikiText := builder.toString;
  //  Apply all formatting rules, in order, to the wiki text
  for each rule: FormatRule in sFormatRules do
    wikiText := rule.apply(wikiText);
  //  Return the resulting HTML with style sheet, if we have content left
  if not TextUtils.isEmpty(wikiText) then
    exit STYLE_SHEET + wikiText
  else
    exit nil
end;

/// <summary>
/// Create a wiki formatting rule.
/// </summary>
/// <param name="pattern">Search string to be compiled into a Pattern.</param>
/// <param name="replaceWith">String to replace any found occurances with.
/// This string can also include back-references into the given pattern.</param>
/// <param name="flags">Any flags to compile the Pattern with.</param>
constructor ExtendedWikiHelper.FormatRule(aPattern: String; replaceWith: String; &flags: Integer);
begin
  mPattern := Pattern.compile(aPattern, &flags);
  mReplaceWith := replaceWith
end;

/// <summary>
/// Create a wiki formatting rule.
/// </summary>
/// <param name="pattern">Search string to be compiled into a Pattern.</param>
/// <param name="replaceWith">String to replace any found occurances with.
/// This string can also include back-references into the given pattern.</param>
constructor ExtendedWikiHelper.FormatRule(aPattern: String; replaceWith: String);
begin
  constructor (aPattern, replaceWith, 0)
end;

/// <summary>
/// Apply this formatting rule to the given input string, and return the
/// resulting new string.
/// </summary>
/// <param name="input"></param>
/// <returns></returns>
method ExtendedWikiHelper.FormatRule.apply(input: String): String;
begin
  var m: Matcher := mPattern.matcher(input);
  exit m.replaceAll(mReplaceWith)
end;

end.