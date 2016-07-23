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
  android.app,
  android.appwidget,
  android.content,
  android.content.res,
  android.net,
  android.os,
  android.text.format,
  android.util,
  android.widget,
  java.util.regex;

type
  /// <summary>
  /// Define a simple widget that shows the Wiktionary "Word of the day." To build
  /// an update we spawn a background {@link Service to perform the API queries.
  /// </summary>
  WordWidget = public class(AppWidgetProvider)
  public
    method onUpdate(aContext: Context; appWidgetManager: AppWidgetManager; appWidgetIds: array of Integer); override;
  end;

  UpdateService nested in WordWidget = public class(Service)
  public
    method onStart(aIntent: Intent; startId: Integer); override;
    method buildUpdate(aContext: Context): RemoteViews;
    method onBind(aIntent: Intent): IBinder; override;
  end;

implementation

method WordWidget.onUpdate(aContext: Context; appWidgetManager: AppWidgetManager; appWidgetIds: array of Integer);
begin
  //  To prevent any ANR timeouts, we perform the update in a service
  aContext.startService(new Intent(aContext, typeOf(UpdateService)))
end;

method WordWidget.UpdateService.onStart(aIntent: Intent; startId: Integer);
begin
  //  Build the widget update for today
  var updateViews: RemoteViews := buildUpdate(self);
  //  Push update for this widget to the home screen
  var thisWidget: ComponentName := new ComponentName(self, typeOf(WordWidget));
  var manager: AppWidgetManager := AppWidgetManager.getInstance(self);
  manager.updateAppWidget(thisWidget, updateViews)
end;

/// <summary>
/// Build a widget update to show the current Wiktionary
/// "Word of the day." Will block until the online API returns.
/// </summary>
/// <param name="context"></param>
/// <returns></returns>
method WordWidget.UpdateService.buildUpdate(aContext: Context): RemoteViews;
begin
  //  Pick out month names from resources
  var res: Resources := aContext.Resources;
  var monthNames: array of String := res.StringArray[R.&array.month_names];
  //  Find current month and day
  var today: Time := new Time();
  today.setToNow;
  //  Build today's page title, like "Wiktionary:Word of the day/March 21"
  var pageName: String := res.getString(R.string.template_wotd_title, monthNames[today.month], today.monthDay);
  var updateViews: RemoteViews := nil;
  var pageContent: String := '';
  try
    //  Try querying the Wiktionary API for today's word
    SimpleWikiHelper.prepareUserAgent(aContext);
    pageContent := SimpleWikiHelper.getPageContent(pageName, false);
  except
    on e: SimpleWikiHelper.ApiException do 
      Log.e('WordWidget', 'Couldn''t contact API', e);
    on e: ParseException do 
      Log.e('WordWidget', 'Couldn''t parse API response', e)
  end;
  //  Use a regular expression to parse out the word and its definition
  var matcher: Matcher := Pattern.compile(SimpleWikiHelper.WORD_OF_DAY_REGEX).matcher(pageContent);
  if matcher.find then 
  begin
    //  Build an update that holds the updated widget contents
    updateViews := new RemoteViews(aContext.PackageName, R.layout.widget_word);
    var wordTitle: String := matcher.&group(1);
    updateViews.setTextViewText(R.id.word_title, wordTitle);
    updateViews.setTextViewText(R.id.word_type, matcher.&group(2));
    updateViews.setTextViewText(R.id.definition, matcher.&group(3).trim);
    //  When user clicks on widget, launch to Wiktionary definition page
    var definePage: String := res.getString(R.string.template_define_url, Uri.encode(wordTitle));
    var defineIntent: Intent := new Intent(Intent.ACTION_VIEW, Uri.parse(definePage));
    var pendingIntent: PendingIntent := pendingIntent.getActivity(aContext, 0, defineIntent, 0);
    updateViews.setOnClickPendingIntent(R.id.widget, pendingIntent);
  end
  else
  begin
    //  Didn't find word of day, so show error message
    updateViews := new RemoteViews(aContext.PackageName, R.layout.widget_message);
    var errorMessage: CharSequence := aContext.Text[R.string.widget_error];
    updateViews.setTextViewText(R.id.message, errorMessage)
  end;
  exit updateViews
end;

method WordWidget.UpdateService.onBind(aIntent: Intent): IBinder;
begin
  //  We don't need to bind to this service
  exit nil
end;

end.