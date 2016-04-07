namespace org.me.tabbedapp;

//Sample app by Brian Long (http://blong.com)

{
  This example shows how to build a simple tabbed application
  This main activity is a TabActivity, and each tab set up on the TabHost has its own activity
  The TabWidget is upodated when you add new tabs onto the TabHost
}

interface

uses
  java.util,
  android.os,
  android.app,
  android.util,
  android.view,
  android.content,
  android.widget;
  
type
  MainActivity = public class(TabActivity)
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  // Set our view from the "main" layout resource
  ContentView := R.layout.main;

  var res := Resources; // Resource object to get Drawables
  var tabHost := TabHost;  // The activity TabHost
  var spec: TabHost.TabSpec;  // Resusable TabSpec for each tab
  var tabIntent: Intent;  // Reusable Intent for each tab

  // Create an Intent to launch an Activity for the tab (to be reused)
  tabIntent := new Intent().setClass(self, typeOf(TabOneActivity));

  // Initialize a TabSpec for each tab and add it to the TabHost
  spec := tabHost.newTabSpec("one").setIndicator(String[R.string.tab_one_title],
                    res.Drawable[R.drawable.ic_tab_one])
                 .setContent(tabIntent);
  tabHost.addTab(spec);

  // Do the same for the other tabs
  tabIntent := new Intent().setClass(self, typeOf(TabTwoActivity));
  spec := tabHost.newTabSpec("two").setIndicator(String[R.string.tab_two_title],
                    res.Drawable[R.drawable.ic_tab_two])
                 .setContent(tabIntent);
  tabHost.addTab(spec);

  tabIntent := new Intent().setClass(self, typeOf(TabThreeActivity));
  spec := tabHost.newTabSpec("three").setIndicator(String[R.string.tab_three_title],
                    res.Drawable[R.drawable.ic_tab_three])
                 .setContent(tabIntent);
  tabHost.addTab(spec);

  tabHost.CurrentTab := 0;
end;

end.
