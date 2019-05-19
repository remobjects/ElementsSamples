namespace LinqToSQL;

interface

uses
  System.Collections.Generic,
  System.Linq,
  System.Data.Linq,
  System.Data.Linq.Mapping,
  System.Text;

type
  [Table(name := 'Person.Contact')]
  Contact = class
  public
    [Column(IsPrimaryKey := true)]
    property ContactID : Integer;

    [Column(Name := 'FirstName')]
    property FirstName : String;

    [Column(Name := 'EmailAddress')]
    property Email : String;

    [Column(Name := 'ModifiedDate')]
    property ModifiedDate : DateTime;
  end;
  
implementation

end.