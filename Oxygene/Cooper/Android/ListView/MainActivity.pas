namespace org.me.listviewapp;

//Sample app by Brian Long (http://blong.com)

{
  This example has a main screen (a ListActivity) as a menu to 2 other screens.
  The main screen offers an About box through its menu.
  The About box is a themed activity and looks like a floating dialog
    (the theme is set in the Android manifest file).
  Both other screens are also scrollable lists.
  One is an Activity that uses a layout file containing a ListView.
  The other is a ListActivity.
  Both lists display a list of countries read in from a string array resource.
  Both lists have the option of using a custom adapter to scroll the list
    as opposed to a standard adapter.
  The choice is stored in a shared preference, accessible throughout the application.
  One list offers the choice via an option dialog.
  The other list invokes a PreferenceActivity to automatically serve up the
    choice using an XML layout description.
  The custom adapter offers section indexing - as you drag the scroller, you can
    readily jump to specific sections of the list, which in this case are the first
    of each group countries starting with each letter of the alphabet.
}


interface

uses
  java.util,
  android.os,
  android.app,
  android.util,
  android.view,
  android.widget,
  android.content;
  
type
  MainActivity = public class(ListActivity)
  private
    //Menu items
    const ABOUT_ID = 0;
    //List items;
    const ID_LIST = 0;
    const ID_LIST2 = 1;
    //Misc
    const Tag = "SampleApp.MainActivity";
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onCreateOptionsMenu(menu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
    method onListItemClick(l: ListView; v: View; position: Integer; id: Int64); override;
    method onBackPressed; override;
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  //Set up for an icon on the main activity title bar
  requestWindowFeature(Window.FEATURE_LEFT_ICON);
  // Set our view from the "main" layout resource
  setContentView(R.layout.main);
  //Now get the icon on the title bar
  setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, R.drawable.icon);
  //Get the titles and subtitles to display in this main screen list from string array resources
  var rows := Resources.StringArray[R.array.menu_titles];
  var rowSubtitles := Resources.StringArray[R.array.menu_subtitles];
  if rows.length <> rowSubtitles.length then
    Log.e(Tag, "Menu titles & subtitles have mismatched lengths");
  //Build an ArrayList of maps containing the information to display
  var listViewContent := new ArrayList<Map<String, Object>>();
  for i: Integer := 0 to rows.length - 1 do
  begin
    var map := new HashMap<String, Object>();
    map.put("heading", rows[i]);
    map.put("subheading", rowSubtitles[i]);
    listViewContent.add(map);
  end;
  //Set up adapter for the ListView using a custom list item template
  ListAdapter := new SimpleAdapter(Self, listViewContent, R.layout.listitem_twolines,
      ["heading", "subheading"], [Android.R.id.text1, Android.R.id.text2]);
end;

method MainActivity.onCreateOptionsMenu(menu: Menu): Boolean;
begin
  var item := menu.add(0, ABOUT_ID, 0, R.string.about_menu);
  //Options menu items support icons
  item.Icon := Android.R.drawable.ic_menu_info_details;
  Result := True;
end;

method MainActivity.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  if item.ItemId = ABOUT_ID then
  begin
    startActivity(new Intent(Self, typeOf(AboutActivity)));
    exit True
  end;
  exit false;
end;

method MainActivity.onListItemClick(l: ListView; v: View; position: Integer; id: Int64);
begin
  case position of
    ID_LIST:  startActivity(new Intent(Self, typeOf(ListViewActivity)));
    ID_LIST2: startActivity(new Intent(Self, typeOf(ListViewActivity2)));
  end;
end;

method MainActivity.onBackPressed;
begin
  inherited;
  Toast.makeText(self, String[R.string.back_pressed], Toast.LENGTH_SHORT).show  
end;

end.