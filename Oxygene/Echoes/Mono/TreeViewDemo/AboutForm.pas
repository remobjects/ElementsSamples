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
  /// Summary description for AboutForm.
  /// </summary>
  AboutForm = partial class(System.Windows.Forms.Form)
  private
    method AboutForm_Load(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(aDisposing: Boolean); override;
  public
    constructor;
  end;

implementation

{$REGION Construction and Disposition}
constructor AboutForm;
begin
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent();

  //
  // TODO: Add any constructor code after InitializeComponent call
  //
end;

method AboutForm.Dispose(aDisposing: Boolean);
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

method AboutForm.AboutForm_Load(sender: System.Object; e: System.EventArgs);
begin
  var resource: String := &Assembly.GetEntryAssembly().GetName().Name + '.images.PrismLogo.png';
  var s: Stream := GetType().Assembly.GetManifestResourceStream(resource);
  if s <> nil then
    pictureBox.Image := new Bitmap(s)
end;

end.