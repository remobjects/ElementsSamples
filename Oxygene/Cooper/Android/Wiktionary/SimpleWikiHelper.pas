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

  protected

    const TAG = 'SimpleWikiHelper';
    /// <summary>
    /// Pull the raw text content of the given URL. This call blocks until the
    /// operation has completed, with timeouts and a per-request buffer.
    /// Throws ApiException If any connection or server error occurs.
    /// </summary>
    /// <param name="url">The exact URL to request.</param>
    /// <returns>The raw content returned by the server.</returns>
    class method getUrlContent(url: String): String;
    begin
      var lConnection := HttpURLConnection(new URL(url).openConnection);
      lConnection.ConnectTimeout := 10000;
      lConnection.ReadTimeout := 10000;
      try
        lConnection.connect;
        if lConnection.ResponseCode ≠ HTTP_STATUS_OK then
          raise new ApiException("Wiktionary returned HTTP " + String.valueOf(lConnection.ResponseCode));
        var lInput := new BufferedInputStream(lConnection.getInputStream);
        try
          var lContent := new ByteArrayOutputStream;
          var lBuffer := new SByte[4096];
          loop begin
            if Thread.currentThread.isInterrupted then
              raise new ApiException("Request cancelled");
            var lCount := lInput.&read(lBuffer);
            if lCount = -1 then
              break;
            lContent.&write(lBuffer, 0, lCount);
          end;
          result := new String(lContent.toByteArray, "UTF-8");
        finally
          lInput.close;
        end;
      except
        on e: IOException do
          raise new ApiException("Problem communicating with API", e);
      finally
        lConnection.disconnect;
      end;
    end;
  public

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
    class method getPageContent(title: String; expandTemplates: Boolean): String;
    begin
      Log.i(TAG, 'Looking for ' + title);
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
  end;

  // Thrown when there were problems contacting the remote API server, either
  // because of a network error, or the server returned a bad status code.
  ApiException nested in SimpleWikiHelper = public class(Exception)
  public

    constructor(detailMessage: String; throwable: Throwable);
    begin
      inherited
    end;
    constructor(detailMessage: String);
    begin
      inherited
    end;
  end;

  // Thrown when there were problems parsing the response to an API call,
  // either because the response was empty, or it was malformed.
  ParseException nested in SimpleWikiHelper = public class(Exception)
  public

    constructor(detailMessage: String; throwable: Throwable);
    begin
      inherited
    end;
  end;

end.