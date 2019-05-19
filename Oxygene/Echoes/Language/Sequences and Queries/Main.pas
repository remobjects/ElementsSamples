namespace Sequences_and_Queries;

interface

uses
  System.Collections.Generic,
  System.Windows.Forms,
  System.Drawing,
  System.Linq, System.Data;

type
  /// <summary>
  /// Summary description for MainForm.
  /// </summary>
  MainForm = partial class(System.Windows.Forms.Form)
  private
    method MainForm_Load(sender: System.Object; e: System.EventArgs);
    method buttonExecute_Click(sender: System.Object; e: System.EventArgs);
    method buttonRefresh_Click(sender: System.Object; e: System.EventArgs);
    method loadData;

    method filterData : sequence of Customer;
    method orderData: sequence of Customer;
    method reverseData: sequence of Customer;
    method takeData: sequence of Customer;
    method skipData: sequence of Customer;
    method drillIntoDetails: sequence of Customer;
    method distinctData (seq : sequence of Customer) : sequence of Customer;
    method selectSubset;
    method useIntermediateVariable : sequence of Customer;
    method joinData;
    method groupData;
    method showGroup;

    method buttonNext_Click(sender: System.Object; e: System.EventArgs);
    method buttonPrev_Click(sender: System.Object; e: System.EventArgs);
    method listBoxQueries_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(disposing: Boolean); override;
  var
    MyCustomers: sequence of Customer;
    groupIndex: Integer;
    Descriptions : sequence of String;

  public
    constructor;
  end;

  type
 Customer = public class
    public
      property CustomerId: String;
      property CompanyName: String;
      property Address: String;
      property City: String;
      property Country: String;
      property OrdersList: sequence of Orders;

      constructor;
      constructor (setCustomerId:String; setCompanyName:String; setAddress:String; setCity:String; setCountry:String; setOrdersList:sequence of Orders);
  end;

 Orders = public class
    property OrderID: Integer;
    property OrderDate: DateTime;
    property Freight: Double;

    constructor (setOrderId:Integer; setOrderDate:DateTime; setFreight:Double);
  end;

  Company = public class
    property CompanyName: String;
    property ContactName: String;
    property ContactTitle: String;

    constructor (setCompanyName: String; setContactName: String; setContactTitle: String);
  end;
implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent();

  //
  // TODO: Add any constructor code after InitializeComponent call
  //
end;

method MainForm.Dispose(disposing: Boolean);
begin
  if disposing then begin
    if assigned(components) then
      components.Dispose();

    //
    // TODO: Add custom disposition code here
    //
  end;
  inherited Dispose(disposing);
end;

constructor Customer;
begin
end;

constructor Customer (setCustomerId:String; setCompanyName:String; setAddress:String; setCity:String; setCountry:String; setOrdersList:sequence of Orders);
begin
  self.CustomerId := setCustomerId;
  self.CompanyName := setCompanyName;
  self.Address := setAddress;
  self.City := setCity;
  self.Country:= setCountry;
  self.OrdersList := setOrdersList;
end;

constructor Orders (setOrderId:Integer; setOrderDate:DateTime; setFreight:Double);
begin
  self.OrderID := setOrderId;
  self.OrderDate := setOrderDate;
  self.Freight := setFreight;
end;

constructor Company (setCompanyName: String; setContactName: String; setContactTitle: String);
begin
  self.CompanyName := setCompanyName;
  self.ContactName := setContactName;
  self.ContactTitle := setContactTitle;
end;
{$ENDREGION}

method MainForm.MainForm_Load(sender: System.Object; e: System.EventArgs);
begin
  loadData();

  Descriptions := Helper.FillDescriptions;
  listBoxQueries.DataSource := Helper.FillQueries();
end;

method MainForm.buttonExecute_Click(sender: System.Object; e: System.EventArgs);
begin
  buttonNext.Visible := false;
  buttonPrev.Visible := false;

  case listBoxQueries.SelectedIndex of
    -1 : MessageBox.Show('Please, select query.', 'Query', MessageBoxButtons.OK, MessageBoxIcon.Warning);
    0  : dataGridViewData.DataSource := filterData.ToArray;
    1  : dataGridViewData.DataSource := orderData.ToArray;
    2  : dataGridViewData.DataSource := reverseData.ToArray;
    3  : dataGridViewData.DataSource := takeData.ToArray;
    4  : dataGridViewData.DataSource := skipData.ToArray;
    5  : selectSubset;
    6  : dataGridViewData.DataSource := distinctData(drillIntoDetails).ToArray;
    7  : groupData;
    8  : joinData;
    9  : dataGridViewData.DataSource := useIntermediateVariable.ToArray;
  end;

  try
    dataGridViewData.Columns['OrdersList'].Visible := false;
  except
  end;
end;

method MainForm.listBoxQueries_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
begin
   textBoxDescription.Text := Descriptions.ElementAt(listBoxQueries.SelectedIndex);
end;

method MainForm.buttonRefresh_Click(sender: System.Object; e: System.EventArgs);
begin
  loadData();
end;

method MainForm.buttonNext_Click(sender: System.Object; e: System.EventArgs);
begin
  groupIndex := groupIndex + 1;
  showGroup;
end;

method MainForm.buttonPrev_Click(sender: System.Object; e: System.EventArgs);
begin
  groupIndex := groupIndex - 1;
  showGroup;
end;

method MainForm.showGroup;
begin
  var groupList := from c in MyCustomers group by c.Country;

  dataGridViewData.DataSource := groupList.ElementAt(groupIndex).ToArray;
  if groupIndex <> groupList.Count-1 then
    buttonNext.Enabled := true
  else
    buttonNext.Enabled := false;

  if groupIndex <> 0 then
    buttonPrev.Enabled := true
  else
    buttonPrev.Enabled := false;
end;

method MainForm.loadData;
begin
  MyCustomers := Helper.FillCustomers();

  dataGridViewData.DataSource := MyCustomers.ToArray;
  dataGridViewData.Columns['OrdersList'].Visible := false;

  buttonNext.Visible := false;
  buttonPrev.Visible := false;
end;

method MainForm.filterData: sequence of Customer;
begin
  result := from c in MyCustomers where c.City = 'London';
end;

method MainForm.orderData: sequence of Customer;
begin
  result := from c in MyCustomers order by c.CompanyName desc;
end;

method MainForm.reverseData: sequence of Customer;
begin
  result := from c in MyCustomers reverse;
end;

method MainForm.takeData: sequence of Customer;
begin
  result := from c in MyCustomers take 7;
end;

method MainForm.skipData: sequence of Customer;
begin
  result := from c in MyCustomers skip 7;
end;

method MainForm.groupData;
begin
  groupIndex := 0;

  buttonNext.Visible := true;
  buttonPrev.Visible := true;

  showGroup;
end;

method MainForm.selectSubset;
begin
  dataGridViewData.DataSource := (from c in MyCustomers select new class (c.CustomerId, Location := c.City + ', ' +c.Country)).ToArray;
end;

method MainForm.drillIntoDetails: sequence of Customer;
begin
  result := from c in MyCustomers where c.City = 'London' from o in c.OrdersList order by o.OrderDate select c;
end;

method MainForm.distinctData (seq : sequence of Customer) : sequence of Customer;
begin
  result := from c in seq distinct;
end;

method MainForm.joinData;
begin
  var Companies := Helper.FillCompanies;
  dataGridViewData.DataSource := (from cust in MyCustomers join comp in Companies on cust.CompanyName equals comp.CompanyName
                                   select new class (cust.CompanyName, cust.City, Contact:= comp.ContactName + ', ' + comp.ContactTitle)).ToArray;
end;

method MainForm.useIntermediateVariable: sequence of Customer;
begin
  result := from c in MyCustomers with Address := c.City+', '+c.Address where Address.Contains('London') select c;
end;

end.