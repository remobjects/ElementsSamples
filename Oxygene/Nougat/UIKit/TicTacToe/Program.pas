namespace TicTacToe;

interface

uses
  UIKit;

type
  Program = public static class
  public
    method Main(argc: Integer; argv: ^^AnsiChar): Int32;
  end;

implementation

method Program.Main(argc: Integer; argv: ^^AnsiChar): Int32;
begin
  using autoreleasepool do begin
    result := UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.class));
  end;
end;

end.
