namespace LinqToXML;

interface

uses
  System.Collections.Generic,
  System.Linq,
  System.Text;

type
  Books = public class
  public
   constructor ( atitle, apublisher : String; ayear : Integer);

   property Publisher : String;
   property Title : String;
   property Year : Integer;


  end;
  
implementation

constructor Books( atitle, apublisher : String; ayear : Integer);
begin

  Title := atitle;
  Publisher := apublisher;
  Year := ayear;

end;

end.