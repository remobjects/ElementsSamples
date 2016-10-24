namespace com.example.android.simplewiktionary;

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
  org.json,
  android.content,
  android.content.pm,
  android.net,
  android.util,
  java.io,
  java.net;

type
  /// <summary>
  /// Helper methods to simplify talking with and parsing responses from a
  /// lightweight Wiktionary API. Before making any requests, you should call
  /// prepareUserAgent(Context) to generate a User-Agent string based on
  /// your application package name and version.
  /// </summary>
  SimpleWikiHelper = public class
  private
    const TAG = 'SimpleWikiHelper';
    // Partial URL to use when requesting the detailed entry for a specific
    // Wiktionary page. Use String.format(String, Object...) to insert
    // the desired page title after escaping it as needed.
    const WIKTIONARY_PAGE =
      'https://en.wiktionary.org/w/api.php?action=query&prop=revisions&titles=%s&' +
      'rvprop=content&format=json%s';
    // Partial URL to append to WIKTIONARY_PAGE when you want to expand
    // any templates found on the requested page. This is useful when browsing
    // full entries, but may use more network bandwidth.
    const WIKTIONARY_EXPAND_TEMPLATES = '&rvexpandtemplates=true';
    // StatusLine HTTP status code when no server error has occurred.
    const HTTP_STATUS_OK = 200;
    // Shared buffer used by getUrlContent(String) when reading results
    // from an API request.
    class var sBuffer: array of SByte := new SByte[512];
  public
    // Regular expression that splits "Word of the day" entry into word
    // name, word type, and the first description bullet point.
    const WORD_OF_DAY_REGEX = '(?s)\{\{wotd\|(.+?)\|(.+?)\|([^#\|]+).*?\}\}';
    class method getPageContent(title: String; expandTemplates: Boolean): String;
  protected
    class method getUrlContent(url: String): String; locked; 
  end;

  // Thrown when there were problems contacting the remote API server, either
  // because of a network error, or the server returned a bad status code.
  ApiException nested in SimpleWikiHelper = public class(Exception)
  public
    constructor(detailMessage: String; throwable: Throwable);
    constructor(detailMessage: String);
  end;

  // Thrown when there were problems parsing the response to an API call,
  // either because the response was empty, or it was malformed.
  ParseException nested in SimpleWikiHelper = public class(Exception)
  public
    constructor(detailMessage: String; throwable: Throwable);
  end;

implementation

/// <summary>
/// Read and return the content for a specific Wiktionary page. This makes a
/// lightweight API call, and trims out just the page content returned.
/// Because this call blocks until results are available, it should not be
/// run from a UI thread.
/// Throws ApiException If any connection or server error occurs.
/// Throws ParseException If there are problems parsing the response.
/// </summary>
/// <param name="title">The exact title of the Wiktionary page requested.</param>
/// <param name="expandTemplates">If true, expand any wiki templates found.</param>
/// <returns>Exact content of page.</returns>
class method SimpleWikiHelper.getPageContent(title: String; expandTemplates: Boolean): String;
begin
  //  Encode page title and expand templates if requested
  var encodedTitle: String := android.net.Uri.encode(title);
  var expandClause: String := if expandTemplates then WIKTIONARY_EXPAND_TEMPLATES else '';
  //  Query the API for content
  var content: String := getUrlContent(String.format(WIKTIONARY_PAGE, encodedTitle, expandClause));
  try
    //  Drill into the JSON response to find the content body
    var response: JSONObject := new JSONObject(content);
    var query: JSONObject := response.JSONObject['query'];
    var pages: JSONObject := query.JSONObject['pages'];
    var page: JSONObject := pages.JSONObject[String(pages.keys.next)];
    var revisions: JSONArray := page.JSONArray['revisions'];
    var revision: JSONObject := revisions.JSONObject[0];
    exit revision.String['*'];
  except
    on e: JSONException do 
      raise new ParseException('Problem parsing API response', e)
  end
end;

/// <summary>
/// Pull the raw text content of the given URL. This call blocks until the
/// operation has completed, and is synchronized because it uses a shared
/// buffer sBuffer.
/// Throws ApiException If any connection or server error occurs.
/// </summary>
/// <param name="url">The exact URL to request.</param>
/// <returns>The raw content returned by the server.</returns>
class method SimpleWikiHelper.getUrlContent(url: String): String;
begin
  var _url := new URL(url);
  var urlConnection: HttpURLConnection := HttpURLConnection(_url.openConnection());
  urlConnection.connect();
  try
    var inputStream: InputStream := new BufferedInputStream(urlConnection.getInputStream());
    var content: ByteArrayOutputStream := new ByteArrayOutputStream;
    //  Read response into a buffered stream
    var readBytes: Integer := 0;
    repeat
      readBytes := inputStream.&read(sBuffer);
      if readBytes <> -1 then
        content.&write(sBuffer, 0, readBytes);
    until readBytes = -1;
    //  Return result from buffered stream
    exit new String(content.toByteArray);
  except
    on e: IOException do 
      raise new ApiException('Problem communicating with API', e)
  finally
    urlConnection.disconnect();
  end;
end;

constructor SimpleWikiHelper.ApiException(detailMessage: String; throwable: Throwable);
begin
  inherited
end;

constructor SimpleWikiHelper.ApiException(detailMessage: String);
begin
  inherited
end;

constructor SimpleWikiHelper.ParseException(detailMessage: String; throwable: Throwable);
begin
  inherited
end;

end.