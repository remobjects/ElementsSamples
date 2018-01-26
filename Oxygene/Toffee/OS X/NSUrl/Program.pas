namespace ZipTest;

interface

uses
  Foundation,
  RemObjects.Elements.RTL;

type
  Program = public static class
  public
    method Main(aArguments: array of String): Int32;
  end;

implementation

method Program.Main(aArguments: array of String): Int32;
begin
  writeLn('The magic happens here.');
  {CHANGE THE PATHS for Your needs}
  var frompath :=  Path.Combine(Environment.UserHomeFolder, '/Documents/test/');
  var topath := Path.Combine(Environment.UserHomeFolder, '/Documents/test.zip');
  writeLn('Zip : '+frompath);
  topath := Zipper.dozip(frompath,topath);
  writeLn('Zipped to: '+topath);
  //readLn;

end;

end.