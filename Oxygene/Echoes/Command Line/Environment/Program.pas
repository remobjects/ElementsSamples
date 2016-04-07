namespace ConsoleApplication1;

//Sample .NET console application
//by Brian Long, 2009

//App is compiled against .NET assemblies and reports various bits of environment information
//Does Win32/Unix differentiation using directory separator check
//Does Linux/OS X differentiation using a Mono class (from Mono.Posix.dll) containing Unix calls

interface

type
  ConsoleApp = class
  private
    class method IsWindows: Boolean;
    //Note - only call these methods if IsWindows has returned False!
    class method IsLinux: Boolean;
    class method IsOSX: Boolean;
    class Method IsMono: Boolean;
    class Method IsDotNet: Boolean;
  public
    class method Main;
  end;

implementation

class method ConsoleApp.IsWindows: Boolean;
begin
  Result := System.IO.Path.DirectorySeparatorChar = '\'
end;

class method ConsoleApp.IsLinux: Boolean;
begin
  if IsWindows then
    
    exit False;
  var buf: Mono.Unix.Native.Utsname;
  
  if Mono.Unix.Native.Syscall.uname(out buf) = 0 then
    
    exit string.Compare(buf.sysname, 'linux', True) = 0;
  Result := false;
end;

class method ConsoleApp.IsOSX: Boolean;
begin
  if IsWindows then
    exit False;
  
  var buf: Mono.Unix.Native.Utsname;
  if Mono.Unix.Native.Syscall.uname(out buf) = 0 then
    exit string.Compare(buf.sysname, 'darwin', True) = 0;
  
  Result := false;
end;

class method ConsoleApp.IsMono: Boolean;
begin
  exit &Type.GetType('Mono.Runtime') <> nil
end;

class method ConsoleApp.IsDotNet: Boolean;
begin
  exit not IsMono()
end;

class method ConsoleApp.Main;
begin
  Console.WriteLine(String.Format('Command line: {0}', Environment.CommandLine));
  Console.WriteLine(String.Format('Current directory: {0}', Environment.CurrentDirectory));
  Console.WriteLine(String.Format('#Processors: {0}', Environment.ProcessorCount));
  Console.WriteLine(String.Format('User name: {0}', Environment.UserName));
  Console.WriteLine(String.Format('Machine name: {0}', Environment.MachineName));
  Console.WriteLine(String.Format('User domain: {0}', Environment.UserDomainName));
  Console.WriteLine(String.Format('Reported OS Version summary: {0}', Environment.OSVersion.VersionString));
  Console.WriteLine(String.Format('Reported OS platform: {0}', Environment.OSVersion.Platform));
  Console.WriteLine(String.Format('Reported OS Version: {0}', Environment.OSVersion.Version));
  Console.WriteLine(String.Format('Reported OS Service Pack: {0}', Environment.OSVersion.ServicePack));
  Console.Write('Actual platform: ');
  if IsWindows then
    Console.WriteLine(String.Format('A Windows platform ({0})', Environment.OSVersion.Platform))
  else if IsLinux then
    Console.WriteLine('Linux')
  else
    Console.WriteLine('Mac OS X');
  Console.WriteLine(String.Format('Execution engine version: {0}', Environment.Version));
  Console.Write('Running .NET or Mono: ');
  if &Type.GetType('Mono.Runtime') = nil then
    Console.WriteLine('.NET')
  else
    Console.WriteLine('Mono');
  Console.WriteLine(String.Format('System dir: {0}', Environment.SystemDirectory));
  Console.WriteLine(String.Format('Application Data folder: {0}', Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)));
  Console.WriteLine(String.Format('Desktop folder: {0}', Environment.GetFolderPath(Environment.SpecialFolder.Desktop)));
  Console.WriteLine(String.Format('Local Application Data folder: {0}', Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData)));
  Console.WriteLine(String.Format('My Documents folder: {0}', Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments)));
  Console.WriteLine(String.Format('My Pictures folder: {0}', Environment.GetFolderPath(Environment.SpecialFolder.MyPictures)));
  Console.WriteLine(String.Format('My Music folder: {0}', Environment.GetFolderPath(Environment.SpecialFolder.MyMusic)));
  Console.WriteLine(String.Format('Personal folder: {0}', Environment.GetFolderPath(Environment.SpecialFolder.Personal)));
  Console.ReadLine();  
end;

end.