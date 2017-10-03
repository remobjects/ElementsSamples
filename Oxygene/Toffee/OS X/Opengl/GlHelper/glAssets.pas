namespace GlHelper;

interface

uses
  rtl,
  {$IF TOFFEE}
  Foundation,
  {$ENDIF}
  RemObjects.Elements.RTL;

type
  Asset = public class
  private
    {$IF ISLAND}
        class var basePath : String;
    {$ENDIF}
  public
   {$IF ISLAND}
    class method initialize(const aBasePath : String);

   {$ENDIF}
       // Loads the Content from aFilename as String
    class method loadFile(const aFilename : String) :  String;
    class method loadFileBytes(const aFilename : String) : Array of Byte;
    class method getFullname(const aFilename : String) : String;
  end;

implementation

class method Asset.loadFile(const aFilename: String): String;
begin
  {$IF ISLAND}
  var  lName := Path.Combine(basePath, aFilename);
  {$ELSEIF TOFFEE}
  var lname : String := aFilename.ToUnixPathFromWindowsPath;
   lname :=  Path.Combine(Bundle.mainBundle.resourcePath, lname);

  {$ENDIF}
   if lname.FileExists then
    exit File.ReadText(lname) else exit nil;

end;

class method Asset.loadFileBytes(const aFilename: String): Array of Byte;
begin
   {$IF ISLAND}
  var lName := Path.Combine(basePath, aFilename);

    {$ELSEIF TOFFEE}
    var lname : String := aFilename.ToUnixPathFromWindowsPath;
     lname :=  Path.Combine(Bundle.mainBundle.resourcePath, lname);
   {$ENDIF}

  if lname.FileExists then
    exit File.ReadBytes(lname) else exit nil;

end;

class method Asset.getFullname(const aFilename: String): String;
begin
   {$IF ISLAND}
  exit Path.Combine(basePath, aFilename);
  {$ELSEIF TOFFEE}
  var lname : String := aFilename.ToUnixPathFromWindowsPath;
  exit  Path.Combine(Bundle.mainBundle.resourcePath, lname);

  {$ENDIF}
end;


 {$IF ISLAND}
class method Asset.initialize(const aBasePath : String);
begin
  basePath := aBasePath;
end;

{$ENDIF}


end.