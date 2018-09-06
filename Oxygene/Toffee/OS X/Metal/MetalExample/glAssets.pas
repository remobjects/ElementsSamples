namespace MetalExample;

interface

uses
  rtl,
  Foundation,
  RemObjects.Elements.RTL;

type
  Asset = public class

 public
       // Loads the Content from aFilename as String
    class method loadFile(const aFilename : String) :  String;
    class method loadFileBytes(const aFilename : String) : Array of Byte;
    class method getFullname(const aFilename : String) : String; inline;
    class method getUrlfor(const aFilename : String) : Foundation.URL;
  end;

implementation

class method Asset.getFullname(const aFilename: String): String;
begin
  exit  Path.Combine(Bundle.mainBundle.resourcePath, aFilename);
end;

class method Asset.loadFile(const aFilename: String): String;
begin
  var
  {$IF TEST}
    var lname : string = "";
   {$ELSE}
      lname :=  getFullname(aFilename);
  {$ENDIF}

   if lname.FileExists then
    exit File.ReadText(lname) else exit nil;
end;

class method Asset.loadFileBytes(const aFilename: String): Array of Byte;
begin
  var lname :=  getFullname(aFilename);
  if lname.FileExists then
    exit File.ReadBytes(lname) else exit nil;
end;


class method Asset.getUrlfor(const aFilename: String): Foundation.Url;
begin
  exit Foundation.URL.fileURLWithPath(getFullname(aFilename));
end;

end.