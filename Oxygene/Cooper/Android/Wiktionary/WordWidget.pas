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
  android.app, android.app.job, android.appwidget, android.content,
  android.content.res, android.net, android.os, android.util, android.widget,
  java.util.concurrent, java.util.regex;

type
  WordWidget = public class(AppWidgetProvider)
  public

    method onUpdate(aContext: Context; aManager: AppWidgetManager; aIds: array of Integer); override;
    begin
      // JobScheduler permits network work after this broadcast receiver returns.
      var lJob := new JobInfo.Builder(1, new ComponentName(aContext, typeOf(UpdateService)));
      lJob.setRequiredNetworkType(JobInfo.NETWORK_TYPE_ANY);
      JobScheduler(aContext.getSystemService(Context.JOB_SCHEDULER_SERVICE)).schedule(lJob.build);
    end;

  end;

  UpdateService nested in WordWidget = public class(JobService)
  private

    const WOTD_PATTERN = '(?s)\{\{wotd\|(.+?)\|(.+?)\|([^#\|]+).*?\}\}';
    field fExecutor: ExecutorService := Executors.newSingleThreadExecutor;
    field fWork: java.util.concurrent.&Future<Object>;
    field fHandler: Handler := new Handler(Looper.MainLooper);
    field fGeneration: Integer;

  public

    method onStartJob(aParameters: JobParameters): Boolean; override;
    begin
      inc(fGeneration);
      var lGeneration := fGeneration;
      fWork := fExecutor.submit(Runnable(method begin
        var lViews := buildUpdate(self);
        fHandler.post(method begin
          if lGeneration ≠ fGeneration then
            exit;
          AppWidgetManager.getInstance(self).updateAppWidget(new ComponentName(self, typeOf(WordWidget)), lViews);
          jobFinished(aParameters, false);
        end);
      end));
      result := true;
    end;

    method onStopJob(aParameters: JobParameters): Boolean; override;
    begin
      inc(fGeneration);
      if assigned(fWork) then
        fWork.cancel(true);
      fHandler.removeCallbacksAndMessages(nil);
      result := true;
    end;

    method onDestroy; override;
    begin
      inc(fGeneration);
      fExecutor.shutdownNow;
      fHandler.removeCallbacksAndMessages(nil);
      inherited;
    end;

    method buildUpdate(aContext: Context): RemoteViews;
    begin
      //  Pick out month names from resources
      var res: Resources := aContext.Resources;
      var monthNames: array of String := res.StringArray[R.&array.month_names];
      //  Find current month and day
      var today := java.util.Calendar.getInstance;
      //  Build the page title for today, such as "March 21"
      var pageName: String := res.getString(R.string.template_wotd_title, monthNames[today.get(java.util.Calendar.MONTH)], today.get(java.util.Calendar.DAY_OF_MONTH));
      var pageContent: String := nil;
      try
        //  Try querying the Wiktionary API for today's word
        pageContent := SimpleWikiHelper.getPageContent(pageName, false);
      except
        on e: SimpleWikiHelper.ApiException do
          Log.e('WordWidget', 'Couldn''t contact API', e);
        on e: SimpleWikiHelper.ParseException do
          Log.e('WordWidget', 'Couldn''t parse API response', e)
      end;
      var views: RemoteViews := nil;
      //  Use a regular expression to parse out the word and its definition
      var matcher: Matcher := Pattern.compile(WOTD_PATTERN).matcher(if assigned(pageContent) then pageContent else "");
      if matcher.find then
      begin
        //  Build an update that holds the updated widget contents
        views := new RemoteViews(aContext.PackageName, R.layout.widget_word);
        var wordTitle: String := matcher.&group(1);
        views.setTextViewText(R.id.word_title, wordTitle);
        views.setTextViewText(R.id.word_type, matcher.&group(2));
        views.setTextViewText(R.id.definition, matcher.&group(3).trim);
        //  When user clicks on widget, launch to Wiktionary definition page
        var definePage: String := WideString.format('%s://%s/%s', ExtendedWikiHelper.WIKI_AUTHORITY, ExtendedWikiHelper.WIKI_LOOKUP_HOST, wordTitle);
        var defineIntent: Intent := new Intent(Intent.ACTION_VIEW, Uri.parse(definePage));
        defineIntent.setClass(aContext, typeOf(LookupActivity));
        var lPendingIntent: PendingIntent := PendingIntent.getActivity(aContext, 0, defineIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget, lPendingIntent)
      end
      else
      begin
        //  Didn't find word of day, so show error message
        views := new RemoteViews(aContext.PackageName, R.layout.widget_message);
        views.setTextViewText(R.id.message, aContext.String[R.string.widget_error])
      end;
      exit views
    end;

  end;

end.
