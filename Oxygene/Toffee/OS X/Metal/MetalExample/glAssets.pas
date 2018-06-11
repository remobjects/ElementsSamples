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
    class method getFullname(const aFilename : String) : String;
    class method getUrlfor(const aFilename : String) : Foundation.URL;
  end;

implementation

class method Asset.loadFile(const aFilename: String): String;
begin
  var lname : String := aFilename.ToUnixPathFromWindowsPath;
   lname :=  Path.Combine(Bundle.mainBundle.resourcePath, lname);
   if lname.FileExists then
    exit File.ReadText(lname) else exit nil;

end;

class method Asset.loadFileBytes(const aFilename: String): Array of Byte;
begin
    var lname : String := aFilename.ToUnixPathFromWindowsPath;
     lname :=  Path.Combine(Bundle.mainBundle.resourcePath, lname);


  if lname.FileExists then
    exit File.ReadBytes(lname) else exit nil;

end;

class method Asset.getFullname(const aFilename: String): String;
begin
  var lname : String := aFilename.ToUnixPathFromWindowsPath;
  exit  Path.Combine(Bundle.mainBundle.resourcePath, lname);
end;


class method Asset.getUrlfor(const aFilename: String): Foundation.Url;
begin
  exit Foundation.URL.fileURLWithPath(Asset.getFullname(aFilename));
end;


end.