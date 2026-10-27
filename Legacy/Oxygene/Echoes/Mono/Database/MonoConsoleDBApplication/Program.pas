namespace MonoConsoleDBApplication;

//Sample Mono console application
//by Brian Long, 2009

//Console application compiled against Mono assemblies.
//Uses MySQL Connector/Net to talk to MySQL:
// - creates a DB & table
// - runs a SELECT statement
// - drops the table & DB
//Works under .NET or Mono if MySQL conector is installed
//MySQL connector available from http://dev.mysql.com/downloads/connector/net

interface

uses
  System.Text,
  System.Data,
  MySql.Data.MySqlClient;                 

type
  ConsoleApp = class
  private
    class method SetupData(sqlConnection: MySqlConnection);
    class method TearDownData(sqlConnection: MySqlConnection);
  public
    class method GetSomeData(): String;
    class method Main;
  end;

implementation

class method ConsoleApp.Main;
begin
  Console.WriteLine(GetSomeData());
  Console.WriteLine();
  Console.WriteLine('Press Enter to continue...');
  Console.ReadLine();
end;

class method ConsoleApp.SetupData(sqlConnection: MySqlConnection);
const
  createSchemaSQL = 'CREATE SCHEMA IF NOT EXISTS `SampleDB`';
  useSchemaSQL = 'USE `SampleDB`;';
  dropTableSQL = 'DROP TABLE IF EXISTS `SampleDB`.`Customers`';
  createTableSQL = 
    'CREATE TABLE  `SampleDB`.`Customers` (' +
    '  `CustID` int(11) NOT NULL auto_increment, ' +
    '  `Name` varchar(45) NOT NULL, ' +
    '  `Town` varchar(45) NOT NULL, ' +
    '  `AccountNo` varchar(10) NOT NULL, ' +
    '  PRIMARY KEY  (`CustID`)' +
    ') ENGINE=MyISAM';
  insertSQLs: Array of String = [
    'INSERT INTO Customers (Name, Town, AccountNo) VALUES (''John Smith'', ''Manchester'', ''0001'')',
    'INSERT INTO Customers (Name, Town, AccountNo) VALUES (''John Doe'', ''Dorchester'', ''0002'')',
    'INSERT INTO Customers (Name, Town, AccountNo) VALUES (''Fred Bloggs'', ''Winchester'', ''0003'')',
    'INSERT INTO Customers (Name, Town, AccountNo) VALUES (''Walter P. Jabsco'', ''Ilchester'', ''0004'')',
    'INSERT INTO Customers (Name, Town, AccountNo) VALUES (''Jane Smith'', ''Silchester'', ''0005'')',
    'INSERT INTO Customers (Name, Town, AccountNo) VALUES (''Raymond Luxury-Yacht'', ''Colchester'', ''0006'')'];
var
  sqlCommand: MySqlCommand := new MySqlCommand();
begin
  sqlCommand.Connection := sqlConnection;
  sqlCommand.CommandText := createSchemaSQL;
  sqlCommand.ExecuteNonQuery();
  sqlCommand.CommandText := useSchemaSQL;
  sqlCommand.ExecuteNonQuery();
  sqlCommand.CommandText := dropTableSQL;
  sqlCommand.ExecuteNonQuery();
  sqlCommand.CommandText := createTableSQL;
  sqlCommand.ExecuteNonQuery();
  for each insertSQL: String in insertSQLs do
  begin
    sqlCommand.CommandText := insertSQL;
    sqlCommand.ExecuteNonQuery();
  end;
end;

class method ConsoleApp.TearDownData(sqlConnection: MySqlConnection);
const
  dropSchemaSQL = 'DROP SCHEMA IF EXISTS `SampleDB`';
  dropTableSQL = 'DROP TABLE IF EXISTS `SampleDB`.`Customers`';
var
  sqlCommand: MySqlCommand := new MySqlCommand();
begin
  sqlCommand.Connection := sqlConnection;
  sqlCommand.CommandText := dropSchemaSQL;
  sqlCommand.ExecuteNonQuery();
  sqlCommand.CommandText := dropTableSQL;
  sqlCommand.ExecuteNonQuery();
end;

class method ConsoleApp.GetSomeData(): string;
const
  rootPassword = '';
  //MySQL Connector/Net connection string
  connectionString = 'Server=localhost;UID=root;Password=' + rootPassword;
  selectSQL = 'SELECT * FROM Customers WHERE Town LIKE ''%che%'';';
  widths: Array of Integer = [3, 22, 12, 6];
var
  results: StringBuilder := new StringBuilder();
begin
  using sqlConnection: MySqlConnection := new MySqlConnection(connectionString) do
  begin
    sqlConnection.Open();
    SetupData(sqlConnection);
    var dataAdapter: MySqlDataAdapter := new MySqlDataAdapter(selectSQL, sqlConnection);
    var dataTable: DataTable := new DataTable('Results');
    dataAdapter.Fill(dataTable);
    for each row: DataRow in dataTable.Rows do
    begin
      results.Append('|');
      for I: Integer := 0 to dataTable.Columns.Count - 1 do
      begin
        var Width := 20;
        if I <= High(widths) then
          Width := widths[I];
        results.AppendFormat('{0,' + Width.ToString() + '}|', row.Item[I]);
      end;
      results.Append(Environment.NewLine);
    end;
    TearDownData(sqlConnection);
  end;
  Result := results.ToString()
end;

end.