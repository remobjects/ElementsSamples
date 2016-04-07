namespace AwaitSample;

interface

uses
  System,
  System.Drawing,
  System.Collections,
  System.Collections.Generic,
  System.Windows.Forms,
  System.ComponentModel,
  System.IO,
  System.Windows.Threading;

type
  MainForm = partial class(System.Windows.Forms.Form)
  private
    const WAIT_MESSAGE = 'Please wait...';

    var fIsRunning: Boolean;

    method buttonCount_Click(sender: System.Object; e: System.EventArgs);
    method buttonChoosePath_Click(sender: System.Object; e: System.EventArgs);
    method CountFiles(path: String): Int32;
  protected
    method Dispose(disposing: Boolean); override;
  public
    constructor;
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  InitializeComponent();
end;

method MainForm.Dispose(disposing: Boolean);
begin
  if disposing then begin
    if assigned(components) then
      components.Dispose();
  end;
  inherited Dispose(disposing);
end;
{$ENDREGION}

method MainForm.buttonChoosePath_Click(sender: System.Object; e: System.EventArgs);
begin
  var lFolderBrowserDialog := new FolderBrowserDialog;

  if (lFolderBrowserDialog.ShowDialog = DialogResult.OK) then
    textBoxPath.Text := lFolderBrowserDialog.SelectedPath
end;

method MainForm.buttonCount_Click(sender: System.Object; e: System.EventArgs);
begin
  if fIsRunning then begin
    MessageBox.Show("Counting process is already running, please wait.", "Warning");
    exit
  end;

  progressBarCounting.Style := ProgressBarStyle.Marquee;

  labelFilesCount.Text := WAIT_MESSAGE;
  fIsRunning := true;

  try
    //Asynconous call definition
    var x := async CountFiles(textBoxPath.Text);
 
	//'Await' allows to use the result of an asynchronous call to continuous operation in a synchronous way, application stays responsive
    labelFilesCount.Text := Convert.ToString(await x);
  except
    on ex: Exception do
    labelFilesCount.Text := 'Error: '+ ex.Message;
  end;

  //When asynchronous operation is finished, application execution continues with next statement
  progressBarCounting.Style := ProgressBarStyle.Continuous;
  fIsRunning := false;
end;

method MainForm.CountFiles(path: String): Int32;
begin
  var lFilesCount: Int32;
  
  try
    lFilesCount := Directory.GetFiles(path).Length;
  except
  end;

  result := lFilesCount;

  var lDirectories: array of String;

  try
    lDirectories := Directory.GetDirectories(path);
  except
  end;

  for each d in lDirectories do
    result := result + CountFiles(d);

end;

end.
