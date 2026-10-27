namespace WinFormsApplication;

interface

{$HIDE H8}

uses
  System.Drawing,
  System.Collections,
  System.Windows.Forms,
  System.ComponentModel;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    components: System.ComponentModel.IContainer;
    notifyIcon: System.Windows.Forms.NotifyIcon;
    aboutToolStripMenuItem: System.Windows.Forms.ToolStripMenuItem;
    helpToolStripMenuItem: System.Windows.Forms.ToolStripMenuItem;
    quitToolStripMenuItem1: System.Windows.Forms.ToolStripMenuItem;
    fileToolStripMenuItem: System.Windows.Forms.ToolStripMenuItem;
    menuStrip1: System.Windows.Forms.MenuStrip;
    quitToolStripMenuItem: System.Windows.Forms.ToolStripMenuItem;
    contextMenuStrip1: System.Windows.Forms.ContextMenuStrip;
    treeView: System.Windows.Forms.TreeView;
    openToolStripMenuItem: System.Windows.Forms.ToolStripMenuItem;
    openFileDialog: System.Windows.Forms.OpenFileDialog;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  self.components := new System.ComponentModel.Container();
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.notifyIcon := new System.Windows.Forms.NotifyIcon(self.components);
  self.contextMenuStrip1 := new System.Windows.Forms.ContextMenuStrip(self.components);
  self.quitToolStripMenuItem := new System.Windows.Forms.ToolStripMenuItem();
  self.menuStrip1 := new System.Windows.Forms.MenuStrip();
  self.fileToolStripMenuItem := new System.Windows.Forms.ToolStripMenuItem();
  self.openToolStripMenuItem := new System.Windows.Forms.ToolStripMenuItem();
  self.quitToolStripMenuItem1 := new System.Windows.Forms.ToolStripMenuItem();
  self.helpToolStripMenuItem := new System.Windows.Forms.ToolStripMenuItem();
  self.aboutToolStripMenuItem := new System.Windows.Forms.ToolStripMenuItem();
  self.treeView := new System.Windows.Forms.TreeView();
  self.openFileDialog := new System.Windows.Forms.OpenFileDialog();
  self.contextMenuStrip1.SuspendLayout();
  self.menuStrip1.SuspendLayout();
  self.SuspendLayout();
  // 
  // notifyIcon
  // 
  self.notifyIcon.ContextMenuStrip := self.contextMenuStrip1;
  self.notifyIcon.Text := 'TreeView Demo';
  self.notifyIcon.Visible := true;
  self.notifyIcon.Click += new System.EventHandler(@self.notifyIcon_Click);
  // 
  // contextMenuStrip1
  // 
  self.contextMenuStrip1.Items.AddRange(array of System.Windows.Forms.ToolStripItem([self.quitToolStripMenuItem]));
  self.contextMenuStrip1.Name := 'contextMenuStrip1';
  self.contextMenuStrip1.Size := new System.Drawing.Size(106, 26);
  // 
  // quitToolStripMenuItem
  // 
  self.quitToolStripMenuItem.Name := 'quitToolStripMenuItem';
  self.quitToolStripMenuItem.Size := new System.Drawing.Size(105, 22);
  self.quitToolStripMenuItem.Text := '&Quit';
  self.quitToolStripMenuItem.Click += new System.EventHandler(@self.quitToolStripMenuItem1_Click);
  // 
  // menuStrip1
  // 
  self.menuStrip1.Items.AddRange(array of System.Windows.Forms.ToolStripItem([self.fileToolStripMenuItem,
      self.helpToolStripMenuItem]));
  self.menuStrip1.Location := new System.Drawing.Point(0, 0);
  self.menuStrip1.Name := 'menuStrip1';
  self.menuStrip1.Size := new System.Drawing.Size(371, 24);
  self.menuStrip1.TabIndex := 1;
  self.menuStrip1.Text := 'menuStrip1';
  // 
  // fileToolStripMenuItem
  // 
  self.fileToolStripMenuItem.DropDownItems.AddRange(array of System.Windows.Forms.ToolStripItem([self.openToolStripMenuItem,
      self.quitToolStripMenuItem1]));
  self.fileToolStripMenuItem.Name := 'fileToolStripMenuItem';
  self.fileToolStripMenuItem.Size := new System.Drawing.Size(35, 20);
  self.fileToolStripMenuItem.Text := '&File';
  // 
  // openToolStripMenuItem
  // 
  self.openToolStripMenuItem.Name := 'openToolStripMenuItem';
  self.openToolStripMenuItem.Size := new System.Drawing.Size(123, 22);
  self.openToolStripMenuItem.Text := '&Open...';
  self.openToolStripMenuItem.Click += new System.EventHandler(@self.openToolStripMenuItem_Click);
  // 
  // quitToolStripMenuItem1
  // 
  self.quitToolStripMenuItem1.Name := 'quitToolStripMenuItem1';
  self.quitToolStripMenuItem1.Size := new System.Drawing.Size(123, 22);
  self.quitToolStripMenuItem1.Text := '&Quit';
  self.quitToolStripMenuItem1.Click += new System.EventHandler(@self.quitToolStripMenuItem1_Click);
  // 
  // helpToolStripMenuItem
  // 
  self.helpToolStripMenuItem.DropDownItems.AddRange(array of System.Windows.Forms.ToolStripItem([self.aboutToolStripMenuItem]));
  self.helpToolStripMenuItem.Name := 'helpToolStripMenuItem';
  self.helpToolStripMenuItem.Size := new System.Drawing.Size(40, 20);
  self.helpToolStripMenuItem.Text := '&Help';
  // 
  // aboutToolStripMenuItem
  // 
  self.aboutToolStripMenuItem.Name := 'aboutToolStripMenuItem';
  self.aboutToolStripMenuItem.Size := new System.Drawing.Size(126, 22);
  self.aboutToolStripMenuItem.Text := '&About...';
  self.aboutToolStripMenuItem.Click += new System.EventHandler(@self.aboutToolStripMenuItem_Click);
  // 
  // treeView
  // 
  self.treeView.Dock := System.Windows.Forms.DockStyle.Fill;
  self.treeView.Location := new System.Drawing.Point(0, 24);
  self.treeView.Name := 'treeView';
  self.treeView.Size := new System.Drawing.Size(371, 202);
  self.treeView.TabIndex := 2;
  // 
  // openFileDialog
  // 
  self.openFileDialog.Filter := 'Managed assemblies (*.exe;*.dll)|*.exe;*.dll)';
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(371, 226);
  self.Controls.Add(self.treeView);
  self.Controls.Add(self.menuStrip1);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MainMenuStrip := self.menuStrip1;
  self.Name := 'MainForm';
  self.Text := 'Assembly enumerator';
  self.Load += new System.EventHandler(@self.MainForm_Load);
  self.contextMenuStrip1.ResumeLayout(false);
  self.menuStrip1.ResumeLayout(false);
  self.menuStrip1.PerformLayout();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.