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
  android.app,
  android.content,
  android.graphics,
  android.net,
  android.os,
  android.text,
  android.text.format,
  android.util,
  android.view,
  android.view.animation,
  android.webkit,
  android.widget,
  java.util,
  java.util.concurrent;

type
  /// <summary>
  /// Activity that lets users browse through Wiktionary content. This is just the
  /// user interface, and all API communication and parsing is handled in
  /// ExtendedWikiHelper.
  /// </summary>
  LookupActivity = public class(Activity, Animation.AnimationListener)
  private

    const TAG = 'LookupActivity';
    field fExecutor: ExecutorService := Executors.newSingleThreadExecutor;
    field fLookup: java.util.concurrent.&Future<Object>;
    field fHandler: Handler := new Handler(Looper.MainLooper);
    field fGeneration: Integer;
    var mTitleBar: View;
    var mTitle: TextView;
    var mProgress: ProgressBar;
    var mWebView: WebView;
    var mSlideIn: Animation;
    var mSlideOut: Animation;
    // History stack of previous words browsed in this session. This is
    // referenced when the user taps the "back" key, to possibly intercept and
    // show the last-visited entry, instead of closing the activity.
    var mHistory: Stack<String> := new Stack<String>;
    var mEntryTitle: String;
    // Keep track of last time user tapped "back" hard key. When pressed more
    // than once within BACK_THRESHOLD, we let the back key fall
    // through and close the app.
    var mLastPress: Int64 := - 1;
    var BACK_THRESHOLD: Int64 := DateUtils.SECOND_IN_MILLIS div 2; readonly;
    /// <summary>
    /// Start navigating to the given word, pushing any current word onto the
    /// history stack if requested. The navigation happens on a background thread
    /// and updates the GUI when finished.
    /// </summary>
    /// <param name="word">The dictionary word to navigate to.</param>
    /// <param name="pushHistory">If true, push the current word onto history stack.</param>
    method startNavigating(aWord: String; pushHistory: Boolean);
    begin
      //  Push any current word onto the history stack
      if not TextUtils.isEmpty(mEntryTitle) and pushHistory then
        mHistory.add(mEntryTitle);
      // Cancellation plus a generation check prevents older results replacing a newer search.
      inc(fGeneration);
      var lGeneration := fGeneration;
      if assigned(fLookup) then
        fLookup.cancel(true);
      mTitleBar.startAnimation(mSlideIn);
      fLookup := fExecutor.submit(Runnable(method begin
        var lQuery := aWord;
        var lContent: String;
        try
          if not assigned(lQuery) then
            lQuery := ExtendedWikiHelper.getRandomWord;
          if assigned(lQuery) then
            lContent := ExtendedWikiHelper.formatWikiText(ExtendedWikiHelper.getPageContent(lQuery, true));
        except
          on e: SimpleWikiHelper.ApiException do
            Log.e(TAG, "Problem making Wiktionary request", e);
          on e: SimpleWikiHelper.ParseException do
            Log.e(TAG, "Problem parsing Wiktionary response", e);
        end;
        fHandler.post(method begin
          if (lGeneration ≠ fGeneration) or isFinishing or isDestroyed then
            exit;
          setEntryTitle(lQuery);
          setEntryContent(if assigned(lContent) then lContent else String[R.string.empty_result]);
          mTitleBar.startAnimation(mSlideOut);
          mProgress.Visibility := View.INVISIBLE;
        end);
      end));
    end;
  protected

    /// <summary>
    /// Show an about dialog that cites data sources.
    /// </summary>
    method showAbout;
    begin
      //  Inflate the about message contents
      var messageView: View := LayoutInflater.inflate(R.layout.about, nil, false);
      //  When linking text, force to always use default color. This works
      //  around a pressed color state bug.
      var txtView: TextView := TextView(messageView.findViewById(R.id.about_credits));
      var defaultColor: Integer := txtView.TextColors.DefaultColor;
      txtView.TextColor := defaultColor;
      var builder: AlertDialog.Builder := new AlertDialog.Builder(self);
      builder.Icon := R.drawable.app_icon;
      builder.Title := R.string.app_name;
      builder.View := messageView;
      builder.&create;
      builder.show
    end;
    /// <summary>
    /// Set the title for the current entry.
    /// </summary>
    method setEntryTitle(entryText: String);
    begin
      mEntryTitle := entryText;
      mTitle.Text := mEntryTitle
    end;
    /// <summary>
    /// Set the content for the current entry. This will update our
    /// WebView to show the requested content.
    /// </summary>
    method setEntryContent(entryContent: String);
    begin
      mWebView.loadDataWithBaseURL(ExtendedWikiHelper.WIKI_AUTHORITY,
        entryContent, ExtendedWikiHelper.MIME_TYPE, ExtendedWikiHelper.ENCODING, nil)
    end;
  public

    method onCreate(savedInstanceState: Bundle); override;
    begin
      inherited;
      ContentView := R.layout.lookup;
      WindowInsetsSupport.apply(self);
      //  Load animations used to show/hide progress bar
      mSlideIn := AnimationUtils.loadAnimation(self, R.anim.slide_in);
      mSlideOut := AnimationUtils.loadAnimation(self, R.anim.slide_out);
      //  Listen for the "in" animation so we make the progress bar visible
      //  only after the sliding has finished.
      mSlideIn.AnimationListener := self;
      mTitleBar := findViewById(R.id.title_bar);
      mTitle := TextView(findViewById(R.id.title));
      mProgress := ProgressBar(findViewById(R.id.progress));
      mWebView := WebView(findViewById(R.id.webview));
      //  Make the view transparent to show background
      mWebView.BackgroundColor := 0;//Color.TRANSPARENT;
      //  Handle incoming intents as possible searches or links
      onNewIntent(Intent)
    end;
    method onDestroy; override;
    begin
      inc(fGeneration);
      if assigned(fLookup) then
        fLookup.cancel(true);
      fExecutor.shutdownNow;
      fHandler.removeCallbacksAndMessages(nil);
      mWebView.stopLoading;
      mWebView.destroy;
      inherited;
    end;
    method onCreateOptionsMenu(mnu: Menu): Boolean; override;
    begin
      var inflater := MenuInflater;
      inflater.inflate(R.menu.lookup, mnu);
      exit true
    end;
    method onOptionsItemSelected(itm: MenuItem): Boolean; override;
    begin
      case itm.ItemId of
        R.id.lookup_search:
        begin
          onSearchRequested;
          exit true
        end;
        R.id.lookup_random:
        begin
          startNavigating(nil, true);
          exit true
        end;
        R.id.lookup_about:
        begin
          showAbout;
          exit true
        end;
      end;
      exit false
    end;
    /// <summary>
    /// Intercept the back-key to try walking backwards along our word history
    /// stack. If we don't have any remaining history, the key behaves normally
    /// and closes this activity.
    /// </summary>
    /// <param name="keyCode"></param>
    /// <param name="event"></param>
    /// <returns></returns>
    method onKeyDown(keyCode: Integer; &event: KeyEvent): Boolean; override;
    begin
      //  Handle back key as long we have a history stack
      if (keyCode = KeyEvent.KEYCODE_BACK) and not mHistory.empty then
      begin
        //  Compare against last pressed time, and if user hit multiple times
        //  in quick succession, we should consider bailing out early.
        var currentPress: Int64 := SystemClock.uptimeMillis;
        if currentPress - mLastPress < BACK_THRESHOLD then
          exit inherited;
        mLastPress := currentPress;
        //  Pop last entry off stack and start loading
        var lastEntry: String := mHistory.pop;
        startNavigating(lastEntry, false);
        exit true
      end;
      //  Otherwise fall through to parent
      exit inherited
    end;
    /// <summary>
    /// Because we're singleTop, we handle our own new intents. These usually
    /// come from the SearchManager when a search is requested, or from
    /// internal links the user clicks on.
    /// </summary>
    method onNewIntent(int: Intent); override;
    begin
      var action: String := int.Action;
      if Intent.ACTION_SEARCH.&equals(action) then
      begin
        //  Start query for incoming search request
        var query: String := int.StringExtra[SearchManager.QUERY];
        startNavigating(query, true)
      end
      else
      if Intent.ACTION_VIEW.&equals(action) then
      begin
        //  Treat as internal link only if valid Uri and host matches
        var data: Uri := int.Data;
        if (data <> nil) and ExtendedWikiHelper.WIKI_LOOKUP_HOST.&equals(data.Host) then
        begin
          var query: String := data.PathSegments.get(0);
          startNavigating(query, true)
        end
      end
      else
      begin
        //  If not recognized, then start showing random word
        startNavigating(nil, true)
      end
    end;
    method onAnimationEnd(animation: Animation);
    begin
      mProgress.Visibility := View.VISIBLE
    end;
    method onAnimationRepeat(animation: Animation);
    //  Not interested if the animation repeats
    begin
    end;
    method onAnimationStart(animation: Animation);
    //  Not interested when the animation starts
    begin
    end;
  end;

end.
