namespace WinFormsApplication;

//Sample WinForms application
//by Brian Long, 2009

//A re-working of a GTK# example program, based on treeview example in the Gtk#
//docs (http://www.go-mono.com/docs/) on the Mono site http://tinyurl.com/Gtk-TreeView

interface

uses
{$REGION Hacking to skip Mono issue}
  System.Runtime.InteropServices,
{$ENDREGION}
  System.Windows.Forms,
  System.Drawing,
  System.Reflection;

type
  /// <summary>
  /// Summary description for MainForm.
  /// </summary>
  MainForm = partial class(System.Windows.Forms.Form)
  private
{$REGION Hacking to skip Mono issue}
    [DllImport('libc')]
    class method uname(buf: IntPtr): Integer; external;
    class method RunningOnUnix: Boolean;
    class method RunningOnLinux: Boolean;
    class method RunningOnOSX: Boolean;
    class method RunningOnWindows: Boolean;
    class method InternalRunningLinuxInsteadOfOSX: Boolean;
{$ENDREGION}
    method MainForm_Load(sender: System.Object; e: System.EventArgs);
    method quitToolStripMenuItem1_Click(sender: System.Object; e: System.EventArgs);
    method aboutToolStripMenuItem_Click(sender: System.Object; e: System.EventArgs);
    method notifyIcon_Click(sender: System.Object; e: System.EventArgs);
    method openToolStripMenuItem_Click(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(disposing: Boolean); override;
  public
    constructor;
    method GetTreeViewNodes: TreeNodeCollection;
  end;

implementation

uses 
  System.Runtime.Versioning;

{$REGION Construction and Disposition}
constructor MainForm;
begin
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent();

  //
  // TODO: Add any constructor code after InitializeComponent call
  //
end;

method MainForm.Dispose(disposing: Boolean);
begin
  if disposing then begin
    if assigned(components) then
      components.Dispose();

    //
    // TODO: Add custom disposition code here
    //
  end;
  inherited Dispose(disposing);
end;
{$ENDREGION}

{$REGION Hacking to skip Mono issue}
class method MainForm.RunningOnUnix: Boolean;
begin
  var p: Integer := Integer(Environment.OSVersion.Platform);
  //.NET 1.x didn't have a Unix value in System.PlatformID enum, so Mono 
  //just used value 128.
  //.NET 2 added Unix to PlatformID, but with value 4
  //.NET 3.5 added MacOSX with a value of 6
  exit p in [4, 6, 128];
end;

class method MainForm.RunningOnLinux: Boolean;
begin
  exit RunningOnUnix and InternalRunningLinuxInsteadOfOSX
end;

class method MainForm.RunningOnOSX: Boolean;
begin
  exit RunningOnUnix and not InternalRunningLinuxInsteadOfOSX
end;

class method MainForm.RunningOnWindows: Boolean;
begin
    Result := not RunningOnUnix
end;

class method MainForm.InternalRunningLinuxInsteadOfOSX: Boolean;
begin
  //based on Mono cross-platform checking code in:
  //  mcs\class\Managed.Windows.Forms\System.Windows.Forms\XplatUI.cs
  if not RunningOnUnix then
    raise new Exception('This is not a Unix platform!');
  var Buf: IntPtr := Marshal.AllocHGlobal(8192);
  try
    if uname(buf) <> 0 then
      //assume Linux of some sort
      exit True
    else
      //Darwin is the Unix variant that OS X is based on
      exit Marshal.PtrToStringAnsi(Buf) <> 'Darwin'
  finally
    Marshal.FreeHGlobal(Buf);
  end;
end;
{$ENDREGION}

method MainForm.MainForm_Load(sender: System.Object; e: System.EventArgs);
begin
  if not RunningOnOSX then
    notifyIcon.Icon := Icon;
end;

method MainForm.quitToolStripMenuItem1_Click(sender: System.Object; e: System.EventArgs);
begin
  if notifyIcon <> nil then
  begin
    if not RunningOnOSX then
      notifyIcon.Visible := False;
    Application.Exit;
  end;
end;

method MainForm.aboutToolStripMenuItem_Click(sender: System.Object; e: System.EventArgs);
begin
  new AboutForm().ShowDialog()
end;

method MainForm.notifyIcon_Click(sender: System.Object; e: System.EventArgs);
begin
  Visible := not Visible
end;

method MainForm.GetTreeViewNodes: TreeNodeCollection;
begin
  Result := treeView.Nodes
end;

method MainForm.openToolStripMenuItem_Click(sender: System.Object; e: System.EventArgs);
begin
  if openFileDialog.ShowDialog = DialogResult.OK then
    Program.AddAssembly(openFileDialog.FileName)
end;

end.