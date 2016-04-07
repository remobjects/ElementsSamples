namespace DLinq;

interface

uses
  System.Linq,
  System.Threading,
  System.Windows.Forms;

type
  Program = assembly static class
  public
    class method Main;
  end;
  
implementation

[STAThread]
class method Program.Main;
begin
  //
  // Get an exception below? make sure to adjust the connection string in app.config!
  //
  var lContext := new DLinq.NorthwindDataContext();
  var lCustomers := lContext.Customers;

  Console.WriteLine();
  Console.WriteLine('Plain list:');
  for each c in lCustomers do
    Console.WriteLine(c.CustomerID+' '+c.CompanyName);
  
  Console.WriteLine();
  Console.WriteLine('Using Extension Methods & Lambda Expression:');
  for each c in lCustomers.Where(c1 -> c1.CompanyName.StartsWith('A')) do
    Console.WriteLine(c.CustomerID+' '+c.CompanyName);

  Console.WriteLine();
  Console.WriteLine('Using Query Expressions:');
  var lCustomers2 := from cust in lCustomers where cust.CompanyName.StartsWith('A');
  for each c in lCustomers2 do begin
    Console.WriteLine(c.CustomerID+' '+c.CompanyName);
    for each o in c.Orders.OrderByDescending(o -> o.OrderDate) do begin
      Console.WriteLine('  Order '+o.OrderID+' placed on '+o.OrderDate);
    end;
  end;

  Console.WriteLine();
  Console.WriteLine('Done; press enter to exit.');
  Console.ReadLine();
end;

end.