namespace LinqToSQL;

interface

uses
  System.Collections.Generic,
  System.Linq,
  System.Data.Linq,
  System.Data.Linq.Mapping,
  System.Text;

type

  [Table(name := 'Production.ProductCategory')]
  Category = class
  public
    [Column(IsPrimaryKey := true, Name := 'ProductCategoryID')]
    property CategoryID : Integer;

    [Column(Name := 'Name')]
    property Name : String;
  end;

  [Table(name := 'Production.ProductSubcategory')]
  SubCategory = class
  public
    [Column(IsPrimaryKey := true, Name := 'ProductSubcategoryID')]
    property SubCategoryID : Integer;

    [Column(Name := 'Name')]
    property SubCatName : String;

    [Column(Name := 'ProductCategoryID')]
    property CategoryID : Integer;

    [Association(OtherKey := 'CategoryID')]
    property Categories : EntitySet<Category>;
  end;
  
implementation

end.