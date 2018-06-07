namespace CustomerList;

interface

uses
  System.Windows.Forms,
  System.Drawing,
  System.Data,
  System.Data.Common,
  System.Data.SqlClient;

type
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    bSaveChanges: System.Windows.Forms.Button;
    MySQLDataAdapter: System.Data.SqlClient.SqlDataAdapter;
    MySQLConnection: System.Data.SqlClient.SqlConnection;
    sqlSelectCommand1: System.Data.SqlClient.SqlCommand;
    sqlInsertCommand1: System.Data.SqlClient.SqlCommand;
    sqlUpdateCommand1: System.Data.SqlClient.SqlCommand;
    sqlDeleteCommand1: System.Data.SqlClient.SqlCommand;
    DataGrid: System.Windows.Forms.DataGrid;
    tbConnectionString: System.Windows.Forms.TextBox;
    bConnect: System.Windows.Forms.Button;
    label1: System.Windows.Forms.Label;
    components: System.ComponentModel.Container := nil;
    method bSaveChanges_Click(sender: System.Object; e: System.EventArgs);
    method bConnect_Click(sender: System.Object; e: System.EventArgs);
    method InitializeComponent;
  {$ENDREGION}
  protected
    fMyDataset : DataSet;

    method Dispose(aDisposing: Boolean); override;
    method GetCustomer: DataTable;
  public
    constructor;
    class method Main;

    property MyDataset : DataSet read fMyDataset;
    property Customers : DataTable read GetCustomer;
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  InitializeComponent();
end;

method MainForm.Dispose(aDisposing: boolean);
begin
  if aDisposing then begin
    if assigned(components) then
      components.Dispose();
  end;
  inherited Dispose(aDisposing);
end;
{$ENDREGION}

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.tbConnectionString := new System.Windows.Forms.TextBox();
  self.label1 := new System.Windows.Forms.Label();
  self.bConnect := new System.Windows.Forms.Button();
  self.DataGrid := new System.Windows.Forms.DataGrid();
  self.MySQLDataAdapter := new System.Data.SqlClient.SqlDataAdapter();
  self.sqlDeleteCommand1 := new System.Data.SqlClient.SqlCommand();
  self.MySQLConnection := new System.Data.SqlClient.SqlConnection();
  self.sqlInsertCommand1 := new System.Data.SqlClient.SqlCommand();
  self.sqlSelectCommand1 := new System.Data.SqlClient.SqlCommand();
  self.sqlUpdateCommand1 := new System.Data.SqlClient.SqlCommand();
  self.bSaveChanges := new System.Windows.Forms.Button();
  (self.DataGrid as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  //
  // tbConnectionString
  //
  self.tbConnectionString.Anchor := (((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Left)
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.tbConnectionString.Location := new System.Drawing.Point(108, 16);
  self.tbConnectionString.Name := 'tbConnectionString';
  self.tbConnectionString.Size := new System.Drawing.Size(344, 20);
  self.tbConnectionString.TabIndex := 0;
  self.tbConnectionString.Text := 'Data Source=localhost;Database=Northwind;Integrated Security=SSPI';
  //
  // label1
  //
  self.label1.Location := new System.Drawing.Point(8, 19);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(100, 14);
  self.label1.TabIndex := 1;
  self.label1.Text := 'Connection String:';
  //
  // bConnect
  //
  self.bConnect.Anchor := ((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.bConnect.Location := new System.Drawing.Point(462, 15);
  self.bConnect.Name := 'bConnect';
  self.bConnect.Size := new System.Drawing.Size(75, 23);
  self.bConnect.TabIndex := 2;
  self.bConnect.Text := '&Connect';
  self.bConnect.Click += new System.EventHandler(@self.bConnect_Click);
  //
  // DataGrid
  //
  self.DataGrid.Anchor := ((((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Bottom)
        or System.Windows.Forms.AnchorStyles.Left)
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.DataGrid.DataMember := '';
  self.DataGrid.HeaderForeColor := System.Drawing.SystemColors.ControlText;
  self.DataGrid.Location := new System.Drawing.Point(8, 56);
  self.DataGrid.Name := 'DataGrid';
  self.DataGrid.Size := new System.Drawing.Size(525, 256);
  self.DataGrid.TabIndex := 3;
  //
  // MySQLDataAdapter
  //
  self.MySQLDataAdapter.DeleteCommand := self.sqlDeleteCommand1;
  self.MySQLDataAdapter.InsertCommand := self.sqlInsertCommand1;
  self.MySQLDataAdapter.SelectCommand := self.sqlSelectCommand1;
  self.MySQLDataAdapter.TableMappings.AddRange(array of System.Data.Common.DataTableMapping([new System.Data.Common.DataTableMapping('Table', 'Customers', array of System.Data.Common.DataColumnMapping([new System.Data.Common.DataColumnMapping('CustomerID', 'CustomerID'),
          new System.Data.Common.DataColumnMapping('CompanyName', 'CompanyName'),
          new System.Data.Common.DataColumnMapping('ContactName', 'ContactName'),
          new System.Data.Common.DataColumnMapping('ContactTitle', 'ContactTitle'),
          new System.Data.Common.DataColumnMapping('Address', 'Address'),
          new System.Data.Common.DataColumnMapping('City', 'City'),
          new System.Data.Common.DataColumnMapping('Region', 'Region'),
          new System.Data.Common.DataColumnMapping('PostalCode', 'PostalCode'),
          new System.Data.Common.DataColumnMapping('Country', 'Country'),
          new System.Data.Common.DataColumnMapping('Phone', 'Phone'),
          new System.Data.Common.DataColumnMapping('Fax', 'Fax')]))]));
  self.MySQLDataAdapter.UpdateCommand := self.sqlUpdateCommand1;
  //
  // sqlDeleteCommand1
  //
  self.sqlDeleteCommand1.CommandText := resources.GetString('sqlDeleteCommand1.CommandText');
  self.sqlDeleteCommand1.Connection := self.MySQLConnection;
  self.sqlDeleteCommand1.Parameters.AddRange(array of System.Data.SqlClient.SqlParameter([new System.Data.SqlClient.SqlParameter('@Original_CustomerID', System.Data.SqlDbType.NVarChar, 5, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'CustomerID', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Address', System.Data.SqlDbType.NVarChar, 60, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Address', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_City', System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'City', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_CompanyName', System.Data.SqlDbType.NVarChar, 40, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'CompanyName', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_ContactName', System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'ContactName', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_ContactTitle', System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'ContactTitle', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Country', System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Country', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Fax', System.Data.SqlDbType.NVarChar, 24, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Fax', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Phone', System.Data.SqlDbType.NVarChar, 24, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Phone', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_PostalCode', System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'PostalCode', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Region', System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Region', System.Data.DataRowVersion.Original, nil)]));
  //
  // MySQLConnection
  //
  self.MySQLConnection.ConnectionString := 'workstation id=BABYBEAST;packet size=4096;user id=sa;data source=".";persist security info=False;initial catalog=Northwind';
  self.MySQLConnection.FireInfoMessageEventOnUserErrors := false;
  //
  // sqlInsertCommand1
  //
  self.sqlInsertCommand1.CommandText := resources.GetString('sqlInsertCommand1.CommandText');
  self.sqlInsertCommand1.Connection := self.MySQLConnection;
  self.sqlInsertCommand1.Parameters.AddRange(array of System.Data.SqlClient.SqlParameter([new System.Data.SqlClient.SqlParameter('@CustomerID', System.Data.SqlDbType.NVarChar, 5, 'CustomerID'),
      new System.Data.SqlClient.SqlParameter('@CompanyName', System.Data.SqlDbType.NVarChar, 40, 'CompanyName'),
      new System.Data.SqlClient.SqlParameter('@ContactName', System.Data.SqlDbType.NVarChar, 30, 'ContactName'),
      new System.Data.SqlClient.SqlParameter('@ContactTitle', System.Data.SqlDbType.NVarChar, 30, 'ContactTitle'),
      new System.Data.SqlClient.SqlParameter('@Address', System.Data.SqlDbType.NVarChar, 60, 'Address'),
      new System.Data.SqlClient.SqlParameter('@City', System.Data.SqlDbType.NVarChar, 15, 'City'),
      new System.Data.SqlClient.SqlParameter('@Region', System.Data.SqlDbType.NVarChar, 15, 'Region'),
      new System.Data.SqlClient.SqlParameter('@PostalCode', System.Data.SqlDbType.NVarChar, 10, 'PostalCode'),
      new System.Data.SqlClient.SqlParameter('@Country', System.Data.SqlDbType.NVarChar, 15, 'Country'),
      new System.Data.SqlClient.SqlParameter('@Phone', System.Data.SqlDbType.NVarChar, 24, 'Phone'),
      new System.Data.SqlClient.SqlParameter('@Fax', System.Data.SqlDbType.NVarChar, 24, 'Fax')]));
  //
  // sqlSelectCommand1
  //
  self.sqlSelectCommand1.CommandText := 'SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax FROM Customers';
  self.sqlSelectCommand1.Connection := self.MySQLConnection;
  //
  // sqlUpdateCommand1
  //
  self.sqlUpdateCommand1.CommandText := resources.GetString('sqlUpdateCommand1.CommandText');
  self.sqlUpdateCommand1.Connection := self.MySQLConnection;
  self.sqlUpdateCommand1.Parameters.AddRange(array of System.Data.SqlClient.SqlParameter([new System.Data.SqlClient.SqlParameter('@CustomerID', System.Data.SqlDbType.NVarChar, 5, 'CustomerID'),
      new System.Data.SqlClient.SqlParameter('@CompanyName', System.Data.SqlDbType.NVarChar, 40, 'CompanyName'),
      new System.Data.SqlClient.SqlParameter('@ContactName', System.Data.SqlDbType.NVarChar, 30, 'ContactName'),
      new System.Data.SqlClient.SqlParameter('@ContactTitle', System.Data.SqlDbType.NVarChar, 30, 'ContactTitle'),
      new System.Data.SqlClient.SqlParameter('@Address', System.Data.SqlDbType.NVarChar, 60, 'Address'),
      new System.Data.SqlClient.SqlParameter('@City', System.Data.SqlDbType.NVarChar, 15, 'City'),
      new System.Data.SqlClient.SqlParameter('@Region', System.Data.SqlDbType.NVarChar, 15, 'Region'),
      new System.Data.SqlClient.SqlParameter('@PostalCode', System.Data.SqlDbType.NVarChar, 10, 'PostalCode'),
      new System.Data.SqlClient.SqlParameter('@Country', System.Data.SqlDbType.NVarChar, 15, 'Country'),
      new System.Data.SqlClient.SqlParameter('@Phone', System.Data.SqlDbType.NVarChar, 24, 'Phone'),
      new System.Data.SqlClient.SqlParameter('@Fax', System.Data.SqlDbType.NVarChar, 24, 'Fax'),
      new System.Data.SqlClient.SqlParameter('@Original_CustomerID', System.Data.SqlDbType.NVarChar, 5, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'CustomerID', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Address', System.Data.SqlDbType.NVarChar, 60, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Address', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_City', System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'City', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_CompanyName', System.Data.SqlDbType.NVarChar, 40, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'CompanyName', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_ContactName', System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'ContactName', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_ContactTitle', System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'ContactTitle', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Country', System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Country', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Fax', System.Data.SqlDbType.NVarChar, 24, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Fax', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Phone', System.Data.SqlDbType.NVarChar, 24, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Phone', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_PostalCode', System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'PostalCode', System.Data.DataRowVersion.Original, nil),
      new System.Data.SqlClient.SqlParameter('@Original_Region', System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, false, (0 as System.Byte), (0 as System.Byte), 'Region', System.Data.DataRowVersion.Original, nil)]));
  //
  // bSaveChanges
  //
  self.bSaveChanges.Anchor := ((System.Windows.Forms.AnchorStyles.Bottom or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.bSaveChanges.Location := new System.Drawing.Point(399, 320);
  self.bSaveChanges.Name := 'bSaveChanges';
  self.bSaveChanges.Size := new System.Drawing.Size(137, 23);
  self.bSaveChanges.TabIndex := 4;
  self.bSaveChanges.Text := 'Save Changes';
  self.bSaveChanges.Click += new System.EventHandler(@self.bSaveChanges_Click);
  //
  // MainForm
  //
  self.AutoScaleBaseSize := new System.Drawing.Size(5, 13);
  self.ClientSize := new System.Drawing.Size(544, 349);
  self.Controls.Add(self.bSaveChanges);
  self.Controls.Add(self.DataGrid);
  self.Controls.Add(self.bConnect);
  self.Controls.Add(self.label1);
  self.Controls.Add(self.tbConnectionString);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MinimumSize := new System.Drawing.Size(500, 250);
  self.Name := 'MainForm';
  self.Text := 'Oxygene ADO.NET Sample - Northwind Customer List';
  (self.DataGrid as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

{$REGION Application Entry Point}
[STAThread]
class method MainForm.Main;
begin
  Application.EnableVisualStyles();
  try
    with lForm := new MainForm() do
      Application.Run(lForm);
  except
    on E: Exception do begin
      MessageBox.Show(E.Message);
    end;
  end;
end;
{$ENDREGION}

method MainForm.bConnect_Click(sender: System.Object; e: System.EventArgs);
begin
  { Refreshes the connection string and opens the connection }
  if (MySQLConnection.State<>ConnectionState.Closed)
    then MySQLConnection.Close;

  MySQLConnection.ConnectionString := tbConnectionString.Text;
  MySQLConnection.Open;

  { Creates the dataset and binds it to the grid }
  fMyDataset := new DataSet;
  MySQLDataAdapter.Fill(MyDataset);

  DataGrid.DataSource := MyDataset.Tables['Customers'];
end;

method MainForm.GetCustomer : DataTable;
begin
  result := MyDataset.Tables['Customers'];
end;

method MainForm.bSaveChanges_Click(sender: System.Object; e: System.EventArgs);
begin
  { Saves the changes to the database }
  MySQLDataAdapter.Update(Customers);
  MessageBox.Show('Your changes have been saved!');
end;

end.