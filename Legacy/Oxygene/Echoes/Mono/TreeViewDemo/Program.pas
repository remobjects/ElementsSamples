namespace WinFormsApplication;

//Sample WinForms application
//by Brian Long, 2009

//A re-working of a GTK# example program, based on treeview example in the Gtk#
//docs (http://www.go-mono.com/docs/) on the Mono site http://tinyurl.com/Gtk-TreeView

//{$define TEST_MODE} //Test mode causes quicker startup, skipping the majority of the methods, types & assemblies

interface

uses
  System.Threading,
  System.Windows.Forms,
  System.Reflection;

type
  Program = assembly static class
  private
    mainForm: MainForm;
    updateDialog: UpdateDialog;
    class method ProcessAssembly(parent: TreeNode; asm: &Assembly);
    class method ProcessType(parent: TreeNode; t: &Type);
    class method UpdateProgress(format: String; params args: Array of object);
    class method OnThreadException(sender: Object; e: ThreadExceptionEventArgs);
  public
    class method Main;
    class method AddAssembly(FileName: String);
  end;
  
implementation

/// <summary>
/// The main entry point for the application.
/// </summary>
[STAThread]
class method Program.Main;
begin
  Application.EnableVisualStyles();
  Application.SetCompatibleTextRenderingDefault(false);
  Application.ThreadException += OnThreadException;
  mainForm := new MainForm;
  //Populate the treeview
  for each asm: &Assembly in AppDomain.CurrentDomain.GetAssemblies() do
  begin
    var asmName: String := asm.GetName().Name;
    UpdateProgress('Loading {0}', asmName);
    ProcessAssembly(mainForm.GetTreeViewNodes.Add(asmName), asm);
{$ifdef TEST_MODE}
    Break;
{$endif}
  end;
  updateDialog.Hide();
  updateDialog := nil;
  Application.Run(mainForm);
end;

class method Program.ProcessAssembly(parent: TreeNode; asm: &Assembly);
begin
  var asmName: String := asm.GetName().Name;
  for each t: &Type in asm.GetTypes() do
  begin
    UpdateProgress('Loading from {0}:'#10'{1}', asmName, t.ToString());
    ProcessType(parent.Nodes.Add(t.ToString()), t);
  end;
end;

class method Program.ProcessType(parent: TreeNode; t: &Type);
begin
  for each mi: MemberInfo in t.GetMembers() do
    parent.Nodes.Add(mi.ToString())
end;

class method Program.UpdateProgress(format: String; params args: Array of object);
begin
  var Text := string.Format(format, args);
  if updateDialog = nil then
  begin
    //First run through needs a new dialog set up and launched
    updateDialog := new UpdateDialog();
    updateDialog.UpdateDialogLabelText(Text);
    updateDialog.Show();
  end
  else
  begin
    //Update dialog text and process pending events to look responsive
    updateDialog.UpdateDialogLabelText(Text);
    Application.DoEvents();
  end;
end;

/// <summary>
/// Default exception handler
/// </summary>
class method Program.OnThreadException(sender: Object; e: ThreadExceptionEventArgs);
begin
  MessageBox.Show(e.Exception.Message);
end;
  
class method Program.AddAssembly(FileName: String);
begin
    var asm: &Assembly := &Assembly.LoadFrom(FileName);
    var asmName: String := asm.GetName().Name;
    //Run the update cycle to add to treeview
    UpdateProgress('Loading {0}', asmName);
    ProcessAssembly(mainForm.GetTreeViewNodes.Add(asmName), asm);
    updateDialog.Hide();
    updateDialog := nil;
end;

end.
