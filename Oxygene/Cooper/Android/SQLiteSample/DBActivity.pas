namespace org.me.sqlitesample;

//Sample app by Brian Long (http://blong.com)

{
  This example demonstrates SQLite's usage in an Android app
  This activity uses helper classes (CustomerDatabaseAdapter and
  CustomerDatabaseHelper), defined in another source file
}

interface

uses
  java.util,
  android.app,
  android.os,
  android.view,
  android.widget,
  android.util;

type
  DBActivity = public class(ListActivity)
  private
    adapter: CustomerDatabaseAdapter;
  protected
    method onDestroy; override;
    method onListItemClick(l: ListView; v: View; position: Integer; id: Int64); override;
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method DBActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  Log.i('DB', 'onCreate');
  ContentView := R.layout.db;
  //Create an instance of our database helper class
  adapter := new CustomerDatabaseAdapter(Self);
  //Open the database
  adapter.Open;
  //These are the field names we'll be displaying
  var fieldsFrom: array of String := [CustomerDatabaseAdapter.ALIAS_FULLNAME, CustomerDatabaseAdapter.FLD_TOWN];
  //This is where we'll display them
  var viewsTo: array of Integer := [Android.R.id.text1, Android.R.id.text2];
  var cursor := adapter.FetchAllCustomers;
  //ensure the cursor gets some Android lifetime management applied to it
  startManagingCursor(cursor);
  //Hook everything up to this ListActivity's ListView
  ListView.Adapter := new SimpleCursorAdapter(self, Android.R.layout.simple_list_item_2, cursor, fieldsFrom, viewsTo);
end;

method DBActivity.onDestroy;
begin
  adapter.Close;
  Log.i('DB', 'onDestroy');
  inherited
end;

method DBActivity.onListItemClick(l: ListView; v: View; position: Integer; id: Int64);
begin
  //When a list item is clicked on, get the customer linked to that DB row id
  var cursor := adapter.FetchCustomer(id);
  //Don't forget the Android lifetime management on this temporary cursor, just in case
  startManagingCursor(cursor);
  //Build up an info string
  var msg := WideString.format('Customer %s, %s from %s row id %s',
    cursor.String[cursor.ColumnIndexOrThrow[CustomerDatabaseAdapter.FLD_LAST]],
    cursor.String[cursor.ColumnIndexOrThrow[CustomerDatabaseAdapter.FLD_FIRST]],
    cursor.String[cursor.ColumnIndexOrThrow[CustomerDatabaseAdapter.FLD_TOWN]],
    id);
  //Briefly display the info string as a short toast message
  Toast.makeText(self, msg, Toast.LENGTH_SHORT).show
end;

end.