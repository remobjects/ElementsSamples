namespace org.me.listviewapp;

{
  This is a ListActivity descendant and so has no layout file
  It automatically gets an item click virtual method, but also hooks up an item long click handler
  This is also hooked up to an adapter to give fast-scrolling
  The adapter is either a standard array adapter or a custom indexed array adapter, 
  based on the value of a shared preference.
  The shared preference can be edited by using the menu to invoke a preference display/edit activity
}

interface

uses
  android.app,
  android.content,
  android.os,
  android.view,
  android.widget,
  android.preference,
  android.util,
  android.net;

type
  ListViewActivity2 = public class(ListActivity)
  private
    const SETTINGS_ID = 1;
    var sharedPrefs: SharedPreferences;
    var useCustomAdapter: Boolean;
  protected
    method onActivityResult(requestCode, resultCode: Integer; data: Intent); override;
    method onListItemClick(l: ListView; v: View; position: Integer; id: Int64); override;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onCreateOptionsMenu(menu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
    method listView_ItemLongClick(parent: AdapterView; v: View; position: Integer; id: Int64): Boolean;
  end;

implementation

method ListViewActivity2.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  //No content view resource loaded
  //Set up a list header
  ListView.addHeaderView(LayoutInflater.inflate(R.layout.listview_header, nil));
  //Add a divider between the header and the list
  ListView.HeaderDividersEnabled := True;
  //Add in the fast-scroll 'thumb bar' button
  ListView.FastScrollEnabled := True;
  var countries := Resources.StringArray[R.array.countries];
  //Check if shared preference indicates we need a custom adapter
  sharedPrefs := PreferenceManager.DefaultSharedPreferences[Self];
  useCustomAdapter := sharedPrefs.Boolean[ListViewActivitySettingsActivity.AdapterPreference, False];
  if useCustomAdapter then
    ListView.Adapter := new ArrayAdapterWithSections(self, R.layout.listitem_twolines, Android.R.id.text1, countries)
  else
    ListView.Adapter := new ArrayAdapter(self, R.layout.listitem_twolines, Android.R.id.text1, countries);
  ListView.OnItemLongClickListener := new interface AdapterView.OnItemLongClickListener(onItemLongClick := @listView_ItemLongClick);
end;

method ListViewActivity2.onCreateOptionsMenu(menu: Menu): Boolean;
begin
  //Create a single item menu shown via the Menu h/w button
  var item := menu.add(0, SETTINGS_ID, 0, R.string.list_activity_settings);
  //Options menu items support icons
  item.Icon := Android.R.drawable.ic_menu_preferences;
  Result := True;
end;

method ListViewActivity2.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  //When menu item is selected...
  if item.ItemId = SETTINGS_ID then
  begin
    //... invoke the settings activity, which will return us a result
    startActivityForResult(new Intent(Self, typeOf(ListViewActivitySettingsActivity)), SETTINGS_ID);
    exit True
  end;
  exit False;
end;

method ListViewActivity2.onActivityResult(requestCode, resultCode: Integer; data: Intent);
begin
  inherited;
  //Execute logic herein when the settings activity returns
  if requestCode = SETTINGS_ID then
  begin
    //Check setting and restart activity if necessary
    var newUseCustomAdapter := sharedPrefs.Boolean[ListViewActivitySettingsActivity.AdapterPreference, False];
    if newUseCustomAdapter <> useCustomAdapter then
    begin
      finish;
      startActivity(new Intent(Self, typeOf(ListViewActivity2)));
    end
  end;
end;

method ListViewActivity2.onListItemClick(l: ListView; v: View; position: Integer; id: Int64);
begin
  //Clicking a country generates a short toast message
  if v is TwoLineListItem then
  begin
    var country := TwoLineListItem(v).Text1.Text.toString;
    Toast.makeText(self, country, Toast.LENGTH_SHORT).show
  end
end;

method ListViewActivity2.listView_ItemLongClick(parent: AdapterView; v: View; position: Integer; id: Int64): Boolean;
begin
  //Long-clicking a country creates a URL to display it in Google Maps,
  //then asks Android to view the URL in a suitable application
  if v is TwoLineListItem then
  begin
    var country := TwoLineListItem(v).Text1.Text.toString;
    startActivity(new Intent(
        Intent.ACTION_VIEW,
        Uri.parse(WideString.format('http://maps.google.com/?t=h&q=%s',
            country.replace(WideString(' '), '%20')))))
  end
end;

end.