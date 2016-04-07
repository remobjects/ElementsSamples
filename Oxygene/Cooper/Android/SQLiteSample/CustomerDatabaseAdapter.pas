namespace org.me.sqlitesample;

//Sample app by Brian Long (http://blong.com)

{
  This source file contains helper classes to
  keep the SQLite access all in one place

  If you deploy this app to the emulator then you can see the database after running the app:

  adb -e shell
  cd data/data/org.me.sqlitesample/databases
  ls -l

  This will list out the database file's directory entry.
  You can also look at the content of the database from inside the adb shell:

  sqlite3 SQLiteSample
  .tables
  .schema Customers
  .dump Customers
  select distinct FirstName from Customers;
  .quit
  exit

}

interface

uses
  java.util,
  android.content,
  android.util,
  android.database.sqlite;

type
  //Database helper class for customer records
  CustomerDatabaseAdapter = public class
  private
    ctx: Context;
    dbHelper: CustomerDatabaseHelper;
    db: SQLiteDatabase;
  public
    const
      Tag = "sqlitesample.CustomerDatabaseAdapter";
      FLD_ID = "_id";
      FLD_FIRST = "FirstName";
      FLD_LAST = "LastName";
      FLD_TOWN = "Town";
      ALIAS_FULLNAME = 'FullName';
      DB_TABLE = "Customers";
  protected
  public
    constructor (aContext: Context);
    method Open: CustomerDatabaseAdapter;
    method Close;
    method FetchCustomer(rowId: Int64): SQLiteCursor;
    method FetchAllCustomers: SQLiteCursor;
  end;

  //Nested SQLite helper class that can create, populate, upgrade and destroy the database
  CustomerDatabaseHelper nested in CustomerDatabaseAdapter = class(SQLiteOpenHelper)
  private
    const
      DB_NAME = "SQLiteSample";
      DB_VER = 2;
      DB_CREATE =
        "create table " + CustomerDatabaseAdapter.DB_TABLE + " (" +
        CustomerDatabaseAdapter.FLD_ID + " integer primary key autoincrement, " +
        CustomerDatabaseAdapter.FLD_FIRST + " text not null, " +
        CustomerDatabaseAdapter.FLD_LAST + " text not null, " +
        CustomerDatabaseAdapter.FLD_TOWN + " text)";
      DB_DESTROY = "drop table if exists " + CustomerDatabaseAdapter.DB_TABLE;
  public
    constructor (aContext: Context);
    method onCreate(db: SQLiteDatabase); override;
    method onUpgrade(db: SQLiteDatabase; oldVersion, newVersion: Integer); override;
    method PrepopulateTable(db: SQLiteDatabase);
    method DropTable(db: SQLiteDatabase);
  end;

implementation

constructor CustomerDatabaseAdapter(aContext: Context);
begin
  ctx := aContext;
end;

method CustomerDatabaseAdapter.Open: CustomerDatabaseAdapter;
begin
  dbHelper := new CustomerDatabaseHelper(ctx);
  db := dbHelper.WritableDatabase;
  exit self
end;

method CustomerDatabaseAdapter.Close;
begin
  dbHelper.close
end;

method CustomerDatabaseAdapter.FetchCustomer(rowId: Int64): SQLiteCursor;
begin
  var cursor := SQLiteCursor(db.query(true, DB_TABLE,
    [FLD_ID, FLD_FIRST, FLD_LAST, FLD_TOWN],
    FLD_ID + '=' + rowId, nil, nil, nil, nil, nil));
  if cursor <> nil then
    cursor.moveToFirst();
  exit cursor
end;

method CustomerDatabaseAdapter.FetchAllCustomers: SQLiteCursor;
begin
  exit SQLiteCursor(db.query(DB_TABLE,
    [FLD_ID, FLD_FIRST + ' || " " || ' + FLD_LAST + ' AS ' + ALIAS_FULLNAME, FLD_TOWN],
    nil, nil, nil, nil, FLD_LAST))
end;

constructor CustomerDatabaseAdapter.CustomerDatabaseHelper(aContext: Context);
begin
  inherited constructor(aContext, DB_NAME, nil, DB_VER)
end;

method CustomerDatabaseAdapter.CustomerDatabaseHelper.onCreate(db: SQLiteDatabase);
begin
  db.execSQL(DB_CREATE);
  PrepopulateTable(db)
end;

method CustomerDatabaseAdapter.CustomerDatabaseHelper.onUpgrade(db: SQLiteDatabase; oldVersion, newVersion: Integer);
begin
  Log.w(Tag, 'Upgrading database from version ' + oldVersion + ' to ' + newVersion + ', which will destroy all old data');
  DropTable(db);
  onCreate(db)
end;

method CustomerDatabaseAdapter.CustomerDatabaseHelper.PrepopulateTable(db: SQLiteDatabase);
begin
  var initialValues := new ContentValues();
  var values: array of array of String :=
    [['John', 'Smith', 'Manchester'],
     ['John', 'Doe', 'Dorchester'],
     ['Fred', 'Bloggs', 'Winchester'],
     ['Walt', 'Jabsco', 'Ilchester'],
     ['Jane', 'Smith', 'Silchester'],
     ['Raymond', 'Luxury-Yacht', 'Colchester']];
  for i: Integer := 0 to length(values)-1 do
  begin
    initialValues.put(FLD_FIRST, values[i, 0]);
    initialValues.put(FLD_LAST, values[i, 1]);
    initialValues.put(FLD_TOWN, values[i, 2]);
    db.insert(DB_TABLE, nil, initialValues);
    initialValues.clear;
  end;
end;

method CustomerDatabaseAdapter.CustomerDatabaseHelper.DropTable(db: SQLiteDatabase);
begin
  db.execSQL(DB_DESTROY)
end;

end.