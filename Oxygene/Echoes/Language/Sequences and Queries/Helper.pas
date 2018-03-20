namespace Sequences_and_Queries;


interface
uses System.Collections.Generic;

type
  Helper = public class
  private
  protected
  public
    class method FillCustomers: sequence of Customer;
    class method FillOrders (number: Integer): sequence of Orders;
    class method FillCompanies: sequence of Company;
    class method FillQueries: sequence of String;
    class method FillDescriptions: sequence of String;
  end;

implementation

class method Helper.FillCustomers: sequence of Customer;
begin
  result := [new Customer('10001', 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', 'Italy', FillOrders(0)),
             new Customer('10002', 'North/South', 'South House 300 Queensbridge', 'London', 'UK', FillOrders(2)),
             new Customer('10003', 'Rattlesnake Canyon Grocery', '2817 London Street', 'Albuquerque', 'USA', FillOrders(2)),
             new Customer('10004', 'The Cracker Box', '55 Grizzly Peak Rd.', 'Butte', 'USA', FillOrders(3)),
             new Customer('10005', 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', 'UK', FillOrders(0)),
             new Customer('10006', 'Bs Beverages', 'Fauntleroy Circus', 'London', 'UK', FillOrders(1)),
             new Customer('10007', 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', 'Germany', FillOrders(4)),
             new Customer('10008', 'La maison d"Asie', '1 rue Alsace-Lorraine', 'Toulouse', 'France', FillOrders(2)),
             new Customer('10009', 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'USA', FillOrders(1)),
             new Customer('10010', 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', 'Germany', FillOrders(1)),
             new Customer('10011', 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'UK', FillOrders(3)),
             new Customer('10012', 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', 'Italy', FillOrders(4)),
             new Customer('10013', 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'USA', FillOrders(0)),
             new Customer('10014', 'Ottilies Kaseladen', 'Mehrheimerstr. 369', 'Koln', 'Germany', FillOrders(2)),
             new Customer('10015', 'Frankenversand', 'Berliner Platz 43', 'Munchen', 'Germany', FillOrders(1))];
end;

class method Helper.FillOrders (number: Integer): sequence of Orders;
begin
  var list : List<Orders> := new List<Orders>;
  var ordersCount : Integer := 3;

  for i : Integer := 0 to ordersCount-1 do
    list.Add(new Orders(12001 + i + number, DateTime.Now.Date.AddDays(i + number), i + number));

  result := list;
end;

class method Helper.FillCompanies: sequence of Company;
begin
  result := [new Company('Reggiani Caseifici', 'Maurizio Moroni', 'Sales Associate'),
             new Company('North/South', 'Simon Crowther', 'Sales Associate'),
             new Company('The Cracker Box', 'Liu Wong', 'Marketing Assistant'),
             new Company('Bs Beverages', 'Victoria Ashworth', 'Sales Representative'),
             new Company('Frankenversand', 'Peter Franken', 'Marketing Manager'),
             new Company('Ernst Handel', 'Roland Mendel', 'Sales Manager'),
             new Company('Island Trading', 'Helen Bennett', 'Marketing Manager'),
             new Company('Maison Dewey', 'Catherine Dewey', 'Sales Agent')];
end;

class method Helper.FillQueries: sequence of String;
begin
  result := ['Filter data', 'Order data', 'Reverce data', 'Take data', 'Skip data', 'Select subset', 'Drill into details + Distinct data',
             'Group data', 'Merge data', 'Using intermediate variables'];
end;

class method Helper.FillDescriptions: sequence of String;
begin
  result := ['Select customers located in London.', 'Order initial data by CompanyName descending.', 'Reverce all initial data.',
             'Take first 7 customers.', 'Take data, skipping 7 customers.', 'Select CustomerId with it"s location.',
             'Get customers located in London and sorted by first OrderDate ascending.', 'Group customers by country.',
             'Get customer"s CompanyName with city and contact person.', 'Get customers living in London, and on London Street.'];
end;

end.