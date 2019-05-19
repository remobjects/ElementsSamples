namespace PlayLister;

{ RemObjects Oxygene Sample application

  This application loops over all mp3 files in a given folder hierarchy
  and creates recursive .m3u playlist files }

interface

uses System.*;

type
  ConsoleApp = class
  private
    class var
      fFiles: ArrayList;
      fMusicFolder, fOutFolder, fPrefix: String;
    class method ProcessFolder(aName: String);
  public
    class method Main(args: array of String);
  end;

implementation

class method ConsoleApp.ProcessFolder(aName: string);
var
  lFiles: array of String;
  lFilename: String;
begin
  //Console.WriteLine('Folder :'+ aName);

  lFiles := Directory.GetFiles(aName);

  if aName = fMusicFolder then
    lFilename := 'All.m3u'
  else
    lFilename := aName.SubString(length(fMusicFolder)+1).Replace('\','-')+'.m3u';

  Console.WriteLine(lFilename);

  { Notice the use of the "using" block, which ensures that the method IDisposable.Dispose will
    be called at the end of the block. FileStream supports IDisposable. }
  using lFile: FileStream := new FileStream(fOutFolder+'\'+lFilename, FileMode.&Create) do begin

    using lWriter: StreamWriter := new StreamWriter(lFile) do begin
      fFiles.Add(lWriter);

      lWriter.WriteLine('#EXTM3U');

      for f: String in lFiles do begin
        if Path.GetExtension(f) = '.mp3' then begin
          lFilename := fPrefix+f.SubString(length(fMusicFolder));
          for w: StreamWriter in fFiles do begin
            w.WriteLine(lFilename);
          end;
        end;
      end;

      lFiles := Directory.GetDirectories(aName);
      for f: String in lFiles do begin
      ProcessFolder(f);
      end;

      fFiles.Remove(lWriter);
    end;
  end;
end;

class method ConsoleApp.Main(args: array of string);
begin
  Console.WriteLine('Oxygene mp3 Playlist Maker');
  Console.WriteLine('Free and unsupported, use at your own risk.');
  Console.WriteLine();

  fFiles := new ArrayList();
  fPrefix := '..\Music';
  fMusicFolder := 'g:\Music';
  fOutFolder := 'g:\Playlists';

  if length(args) = 1 then begin
    fMusicFolder := Path.Combine(args[0],'Music');
    fOutFolder := Path.Combine(args[0],'Playlists');
  end
  else if length(args) > 1 then begin
  fMusicFolder := args[0];
  fOutFolder := args[1];
  if length(args) >= 3 then
    fPrefix := args[2];
  end
  else begin
    Console.WriteLine('Syntax');
    Console.WriteLine('  PlayLister <Gmini drive>');
    Console.WriteLine('  PlayLister <MusicFolder> <PlaylistFolder> [<Path Prefix in m3u>]');
    Console.WriteLine;
    Console.WriteLine('Examples:');
    Console.WriteLine('  PlayLister g:\');
    Console.WriteLine('  PlayLister x:\Music x:\Playlists');
    Console.WriteLine('  PlayLister x:\Music x:\Playlists ..\Music');
    Console.WriteLine('  PlayLister x:\Music x:\Playlists \MyMusic');
    Console.WriteLine;
    Console.WriteLine('  The first syntax assumes that the \Music and \Playlists folders are');
    Console.WriteLine('  located in the root of the specified drive and the ..\Music path prefix.');
    Console.WriteLine;
    Console.WriteLine('  If no path prefix is specified ..\Music will always be assumed.');
    Console.WriteLine;
    exit;
  end;

  Console.WriteLine('Music folder:    '+ fMusicFolder);
  Console.WriteLine('Playlist folder: '+ fOutFolder);

  ProcessFolder(fMusicFolder);

  //Console.ReadLine();
end;

end.