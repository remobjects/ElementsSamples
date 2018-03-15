namespace Filefind;

{ RemObjects Oxygene Sample application

  This application lists all files in the current directory and
  in all subdirectories of current directory, that satisfy to the given mask.
}

interface

uses System.*;

type
  ConsoleApp = static class
  private
    class method Shorten(aFolderName: String): String;
    class method ProcessFolder(aFolderName, aMask: String);
  public
    class method Main(args: array of String);
  end;

implementation

class method ConsoleApp.ProcessFolder(aFolderName, aMask: string);
var
  lFiles: array of String;
begin
  Console.CursorLeft := 0;
  Console.Write(Shorten(aFolderName));

  try

    lFiles := Directory.GetFiles(aFolderName, aMask);
    for each f in lFiles do begin
      Console.WriteLine();
      Console.WriteLine('  '+Path.GetFileName(f));
    end;

    lFiles := Directory.GetDirectories(aFolderName);
    for each d in lFiles do begin
      ProcessFolder(d, aMask);
    end;
  except
    on E: DirectoryNotFoundException, UnauthorizedAccessException do begin
      //Console.WriteLine('  '+E.Message);
    end;
  end;

end;

class method ConsoleApp.Main(args: array of string);
begin
  Console.WriteLine('RemObjects Oxygene Filefind utility.');
  Console.WriteLine('Free and unsupported, use at your own risk.');
  Console.WriteLine();

  if length(args) = 1 then begin
    ProcessFolder(System.Environment.CurrentDirectory, args[0]);
    Console.WriteLine();
    Console.WriteLine('Done.');
    Console.WriteLine();
  end
  else begin
    Console.WriteLine('Syntax');
    Console.WriteLine('  Filefind <Mask>');
    Console.WriteLine();
    exit;
  end;

end;

class method ConsoleApp.Shorten(aFolderName: string): string;
begin
  var lWidth := Console.WindowWidth-1;

  if aFolderName.Length > lWidth then begin
    var lStart := aFolderName.IndexOf(Path.DirectorySeparatorChar, 2);
    if (lStart > 40) or (lStart = -1) then lStart := aFolderName.IndexOf(Path.DirectorySeparatorChar);

    result := aFolderName.Substring(1, lStart)+'...'+Path.DirectorySeparatorChar;
    result := result+aFolderName.Substring(lWidth-result.Length);
  end
  else result := aFolderName;

  if result.Length < lWidth then
    result := result.PadRight(lWidth);
end;

end.