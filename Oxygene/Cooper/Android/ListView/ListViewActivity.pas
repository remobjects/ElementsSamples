namespace org.me.listviewapp;

{
  This is a regular Activity descendant using a layout file containing a ListView
  It hooks up item click and item long click handlers
  This is also hooked up to an adapter to give fast-scrolling
  The adapter is either a standard array adapter or a custom indexed array adapter, 
  based on the value of a shared preference.
  The shared preference can be edited by using the menu to invoke a simple single-choice item list dialog
  In this activity the ShowDialog/OnCreateDialog helpers pair are used to set up the dialog
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
  ListViewActivity = public class(Activity)
  private
    const SETTINGS_ID = 1;
    const SETTINGS_DLG = 1;
    var sharedPrefs: SharedPreferences;
    var useCustomAdapter: Boolean;
  protected
    method onCreateDialog(Id: Integer): Dialog; override;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onCreateOptionsMenu(menu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
    method listView_ItemClick(parent: AdapterView; v: View; position: Integer; id: Int64);
    method listView_ItemLongClick(parent: AdapterView; v: View; position: Integer; id: Int64): Boolean;
    method dialogButton_Click(dlg: DialogInterface; which: Integer);
  end;

implementation

method ListViewActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  setContentView(R.layout.main);
  var lstView := ListView(findViewById(Android.R.id.list));
  //Set up a list header
  lstView.addHeaderView(LayoutInflater.inflate(R.layout.listview_header, nil));
  //Add a divider between the header and the list
  lstView.HeaderDividersEnabled := True;
  //Add in the fast-scroll 'thumb bar' button
  lstView.FastScrollEnabled := True;
  var countries := Resources.StringArray[R.array.countries];
  //Check if shared preference indicates we need a custom adapter
  sharedPrefs := PreferenceManager.DefaultSharedPreferences[Self];
  useCustomAdapter := sharedPrefs.Boolean[ListViewActivitySettingsActivity.AdapterPreference, False];
  if useCustomAdapter then
    lstView.Adapter := new ArrayAdapterWithSections(self, R.layout.listitem_twolines, Android.R.id.text1, countries)
  else
    lstView.Adapter := new ArrayAdapter(self, R.layout.listitem_twolines, Android.R.id.text1, countries);
  lstView.OnItemClickListener := new interface AdapterView.OnItemClickListener(onItemClick := @listView_ItemClick);
  lstView.OnItemLongClickListener := new interface AdapterView.OnItemLongClickListener(onItemLongClick := @listView_ItemLongClick);
end;

method ListViewActivity.onCreateOptionsMenu(menu: Menu): Boolean;
begin
  //Create a single item menu shown via the Menu h/w button
  var item := menu.add(0, SETTINGS_ID, 0, R.string.list_activity_settings);
  //Options menu items support icons
  item.Icon := Android.R.drawable.ic_menu_preferences;
  Result := True;
end;

method ListViewActivity.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  //When menu item is selected...
  if item.ItemId = SETTINGS_ID then
  begin
    //... invoke the settings dialog
    showDialog(SETTINGS_DLG);
    exit True
  end;
  exit False;
end;

//On first invocation of a dialog, this method creates it
method ListViewActivity.onCreateDialog(Id: Integer): Dialog;
begin
  inherited;
  if Id = SETTINGS_DLG then
  begin
    var builder := new AlertDialog.Builder(Self);
    builder.Title := R.string.list_activity_settings;
    builder.Cancelable := True;
    builder.setSingleChoiceItems(
      R.array.custom_adapter_preferences,
      //Ensure correct option is selected based on current shared preference value
      iif(useCustomAdapter, 1, 0),
      new interface DialogInterface.OnClickListener(onClick := @dialogButton_Click));
    Result := builder.&create;
  end;
end;

method ListViewActivity.dialogButton_Click(dlg: DialogInterface; which: Integer);
begin
  //Only run the logic in here if a different option is selected 
  if which <> iif(useCustomAdapter, 1, 0) then
  begin
    //Based on which option was selected, update the shared preference
    var editor := sharedPrefs.edit;
    editor.putBoolean(ListViewActivitySettingsActivity.AdapterPreference, which = 1);
    editor.commit;
    //Restart this list view activity to reflect updated adapter selection
    finish;
    startActivity(new Intent(Self, typeOf(ListViewActivity)));
  end;
end;

method ListViewActivity.listView_ItemClick(parent: AdapterView; v: View; position: Integer; id: Int64);
begin
  //Clicking a country generates a short toast message
  if v is TwoLineListItem then
  begin
    var country := TwoLineListItem(v).Text1.Text.toString;
    Toast.makeText(self, country, Toast.LENGTH_SHORT).show
  end
end;

method ListViewActivity.listView_ItemLongClick(parent: AdapterView; v: View; position: Integer; id: Int64): Boolean;
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
