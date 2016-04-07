namespace NSMenu;

interface

uses
  AppKit;

type
  Program = public static class
  public
    method Main(argc: Integer; argv: ^^AnsiChar): Int32;
  end;

implementation

method Program.Main(argc: Integer; argv: ^^AnsiChar): Int32;
begin
  result := NSApplicationMain(argc, argv);
end;

end.
