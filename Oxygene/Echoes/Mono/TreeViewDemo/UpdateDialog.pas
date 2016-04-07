namespace WinFormsApplication;

interface

uses
  System.IO,
  System.Drawing,
  System.Collections,
  System.Collections.Generic,
  System.Windows.Forms,
  System.ComponentModel,
  System.Reflection;

type
  /// <summary>
  /// Summary description for UpdateDialog.
  /// </summary>
  UpdateDialog = partial class(System.Windows.Forms.Form)
  private
    method UpdateDialog_Load(sender: System.Object; e: System.EventArgs);
    method quitButton_Click(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(aDisposing: Boolean); override;
  public
    constructor;
    method UpdateDialogLabelText(Text: String);
  end;

implementation

{$REGION Construction and Disposition}
constructor UpdateDialog;
begin
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent();

  //
  // TODO: Add any constructor code after InitializeComponent call
  //
end;

method UpdateDialog.Dispose(aDisposing: Boolean);
begin
  if aDisposing then begin
    if assigned(components) then
      components.Dispose();

    //
    // TODO: Add custom disposition code here
    //
  end;
  inherited Dispose(aDisposing);
end;
{$ENDREGION}

method UpdateDialog.UpdateDialog_Load(sender: System.Object; e: System.EventArgs);
begin
  var resource: String := &Assembly.GetEntryAssembly().GetName().Name + '.images.Information.png';
  var s: Stream := GetType().Assembly.GetManifestResourceStream(resource);
  if s <> nil then
    pictureBox.Image := new Bitmap(s)
end;

method UpdateDialog.quitButton_Click(sender: System.Object; e: System.EventArgs);
begin
  Environment.Exit(0)
end;

method UpdateDialog.UpdateDialogLabelText(Text: String);
begin
  dialogLabel.Text := Text;
end;

end.