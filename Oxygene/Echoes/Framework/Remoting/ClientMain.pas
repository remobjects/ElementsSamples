namespace Client;

interface

uses
  System.Windows.Forms, 
  System.Drawing,
  System.Runtime.Remoting,
  System.Runtime.Remoting.Channels,
  System.Runtime.Remoting.Channels.HTTP,
  RemotingSample.Interfaces;

type
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    bSum: System.Windows.Forms.Button;
    components: System.ComponentModel.Container := nil;
    method bSum_Click(sender: System.Object; e: System.EventArgs);
    method MainForm_Load(sender: System.Object; e: System.EventArgs);
    method InitializeComponent;
  {$ENDREGION}
  protected
    fChannel : HttpChannel;
    fRemoteService : IRemoteService;

    method Dispose(aDisposing: boolean); override;
  public
    constructor;
    class method Main;
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  InitializeComponent();
end;

method MainForm.Dispose(aDisposing: boolean);
begin
  if aDisposing then begin
    if assigned(components) then
      components.Dispose();
  end;
  inherited Dispose(aDisposing);
end;
{$ENDREGION}

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.bSum := new System.Windows.Forms.Button();
  self.SuspendLayout();
  // 
  // bSum
  // 
  self.bSum.Location := new System.Drawing.Point(47, 50);
  self.bSum.Name := 'bSum';
  self.bSum.Size := new System.Drawing.Size(150, 23);
  self.bSum.TabIndex := 0;
  self.bSum.Text := 'Sum 1+2';
  self.bSum.Click += new System.EventHandler(@self.bSum_Click);
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(244, 122);
  self.Controls.Add(self.bSum);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'RemotingSample Client';
  self.Load += new System.EventHandler(@self.MainForm_Load);
  self.ResumeLayout(false);
end;
{$ENDREGION}

{$REGION Application Entry Point}
[STAThread]
class method MainForm.Main;
begin
  Application.EnableVisualStyles();
  try
    with lForm := new MainForm() do
      Application.Run(lForm);
  except
    on E: Exception do begin
      MessageBox.Show(E.Message);
    end;
  end;
end;
{$ENDREGION}

method MainForm.MainForm_Load(sender: System.Object; e: System.EventArgs);
const
  DefaultPort = 8033;
begin
  // Creates the remoting channel
  fChannel := new HttpChannel();
  ChannelServices.RegisterChannel(fChannel, false);

  // Creates a proxy
  fRemoteService := Activator.GetObject(
    typeof(IRemoteService),
    'http://localhost:'+DefaultPort+'/RemoteService.soap') as IRemoteService;   
end;

method MainForm.bSum_Click(sender: System.Object; e: System.EventArgs);
begin
  MessageBox.Show('1+2='+fRemoteService.Sum(1,2).ToString );
end;

end.
