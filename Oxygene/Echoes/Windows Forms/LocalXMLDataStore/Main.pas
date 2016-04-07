namespace LocalXMLDataStore;

interface

uses
  System.IO,
  System.Windows.Forms,
  System.Drawing, System.Reflection;

type
  /// <summary>
  /// Summary description for MainForm.
  /// </summary>
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    iDDataGridViewTextBoxColumn: System.Windows.Forms.DataGridViewTextBoxColumn;
    nameDataGridViewTextBoxColumn: System.Windows.Forms.DataGridViewTextBoxColumn;
    emailDataGridViewTextBoxColumn: System.Windows.Forms.DataGridViewTextBoxColumn;
    bindingNavigator1: System.Windows.Forms.BindingNavigator;
    bindingNavigatorAddNewItem: System.Windows.Forms.ToolStripButton;
    bindingSource1: System.Windows.Forms.BindingSource;
    bindingNavigatorCountItem: System.Windows.Forms.ToolStripLabel;
    bindingNavigatorDeleteItem: System.Windows.Forms.ToolStripButton;
    bindingNavigatorMoveFirstItem: System.Windows.Forms.ToolStripButton;
    bindingNavigatorMovePreviousItem: System.Windows.Forms.ToolStripButton;
    bindingNavigatorSeparator: System.Windows.Forms.ToolStripSeparator;
    bindingNavigatorPositionItem: System.Windows.Forms.ToolStripTextBox;
    bindingNavigatorSeparator1: System.Windows.Forms.ToolStripSeparator;
    bindingNavigatorMoveNextItem: System.Windows.Forms.ToolStripButton;
    bindingNavigatorMoveLastItem: System.Windows.Forms.ToolStripButton;
    bindingNavigatorSeparator2: System.Windows.Forms.ToolStripSeparator;
    components: System.ComponentModel.IContainer;
    localData1: LocalXMLDataStore.LocalData;
    dataGridView1: System.Windows.Forms.DataGridView;
    method InitializeComponent;
  {$ENDREGION}
  private
    fLocalDirectory : string;
    fDataFileName : string;

    method MainForm_FormClosing(sender: System.Object; e: System.Windows.Forms.FormClosingEventArgs);
  protected
    method Dispose(aDisposing: boolean); override;
  public
    constructor;
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent();

  fLocalDirectory := Path.GetDirectoryName(&Assembly.GetExecutingAssembly.Location);
  fDataFileName := Path.Combine(fLocalDirectory,'store.xml');

  if File.Exists(fDataFileName) then
    localData1.ReadXml(fDataFileName);
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
  self.components := new System.ComponentModel.Container();
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
  self.dataGridView1 := new System.Windows.Forms.DataGridView();
  self.bindingNavigator1 := new System.Windows.Forms.BindingNavigator(self.components);
  self.bindingNavigatorAddNewItem := new System.Windows.Forms.ToolStripButton();
  self.bindingNavigatorCountItem := new System.Windows.Forms.ToolStripLabel();
  self.bindingNavigatorDeleteItem := new System.Windows.Forms.ToolStripButton();
  self.bindingNavigatorMoveFirstItem := new System.Windows.Forms.ToolStripButton();
  self.bindingNavigatorMovePreviousItem := new System.Windows.Forms.ToolStripButton();
  self.bindingNavigatorSeparator := new System.Windows.Forms.ToolStripSeparator();
  self.bindingNavigatorPositionItem := new System.Windows.Forms.ToolStripTextBox();
  self.bindingNavigatorSeparator1 := new System.Windows.Forms.ToolStripSeparator();
  self.bindingNavigatorMoveNextItem := new System.Windows.Forms.ToolStripButton();
  self.bindingNavigatorMoveLastItem := new System.Windows.Forms.ToolStripButton();
  self.bindingNavigatorSeparator2 := new System.Windows.Forms.ToolStripSeparator();
  self.bindingSource1 := new System.Windows.Forms.BindingSource(self.components);
  self.localData1 := new LocalXMLDataStore.LocalData();
  self.iDDataGridViewTextBoxColumn := new System.Windows.Forms.DataGridViewTextBoxColumn();
  self.nameDataGridViewTextBoxColumn := new System.Windows.Forms.DataGridViewTextBoxColumn();
  self.emailDataGridViewTextBoxColumn := new System.Windows.Forms.DataGridViewTextBoxColumn();
  (self.dataGridView1 as System.ComponentModel.ISupportInitialize).BeginInit();
  (self.bindingNavigator1 as System.ComponentModel.ISupportInitialize).BeginInit();
  self.bindingNavigator1.SuspendLayout();
  (self.bindingSource1 as System.ComponentModel.ISupportInitialize).BeginInit();
  (self.localData1 as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // dataGridView1
  // 
  self.dataGridView1.AutoGenerateColumns := false;
  self.dataGridView1.ColumnHeadersHeightSizeMode := System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
  self.dataGridView1.Columns.AddRange(array of System.Windows.Forms.DataGridViewColumn([self.iDDataGridViewTextBoxColumn,
      self.nameDataGridViewTextBoxColumn,
      self.emailDataGridViewTextBoxColumn]));
  self.dataGridView1.DataSource := self.bindingSource1;
  self.dataGridView1.Dock := System.Windows.Forms.DockStyle.Fill;
  self.dataGridView1.Location := new System.Drawing.Point(0, 25);
  self.dataGridView1.Name := 'dataGridView1';
  self.dataGridView1.Size := new System.Drawing.Size(596, 302);
  self.dataGridView1.TabIndex := 0;
  // 
  // bindingNavigator1
  // 
  self.bindingNavigator1.AddNewItem := self.bindingNavigatorAddNewItem;
  self.bindingNavigator1.BindingSource := self.bindingSource1;
  self.bindingNavigator1.CountItem := self.bindingNavigatorCountItem;
  self.bindingNavigator1.DeleteItem := self.bindingNavigatorDeleteItem;
  self.bindingNavigator1.Items.AddRange(array of System.Windows.Forms.ToolStripItem([self.bindingNavigatorMoveFirstItem,
      self.bindingNavigatorMovePreviousItem,
      self.bindingNavigatorSeparator,
      self.bindingNavigatorPositionItem,
      self.bindingNavigatorCountItem,
      self.bindingNavigatorSeparator1,
      self.bindingNavigatorMoveNextItem,
      self.bindingNavigatorMoveLastItem,
      self.bindingNavigatorSeparator2,
      self.bindingNavigatorAddNewItem,
      self.bindingNavigatorDeleteItem]));
  self.bindingNavigator1.Location := new System.Drawing.Point(0, 0);
  self.bindingNavigator1.MoveFirstItem := self.bindingNavigatorMoveFirstItem;
  self.bindingNavigator1.MoveLastItem := self.bindingNavigatorMoveLastItem;
  self.bindingNavigator1.MoveNextItem := self.bindingNavigatorMoveNextItem;
  self.bindingNavigator1.MovePreviousItem := self.bindingNavigatorMovePreviousItem;
  self.bindingNavigator1.Name := 'bindingNavigator1';
  self.bindingNavigator1.PositionItem := self.bindingNavigatorPositionItem;
  self.bindingNavigator1.Size := new System.Drawing.Size(596, 25);
  self.bindingNavigator1.TabIndex := 1;
  self.bindingNavigator1.Text := 'bindingNavigator1';
  // 
  // bindingNavigatorAddNewItem
  // 
  self.bindingNavigatorAddNewItem.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
  self.bindingNavigatorAddNewItem.Image := (resources.GetObject('bindingNavigatorAddNewItem.Image') as System.Drawing.Image);
  self.bindingNavigatorAddNewItem.Name := 'bindingNavigatorAddNewItem';
  self.bindingNavigatorAddNewItem.RightToLeftAutoMirrorImage := true;
  self.bindingNavigatorAddNewItem.Size := new System.Drawing.Size(23, 22);
  self.bindingNavigatorAddNewItem.Text := 'Add new';
  // 
  // bindingNavigatorCountItem
  // 
  self.bindingNavigatorCountItem.Name := 'bindingNavigatorCountItem';
  self.bindingNavigatorCountItem.Size := new System.Drawing.Size(36, 22);
  self.bindingNavigatorCountItem.Text := 'of {0}';
  self.bindingNavigatorCountItem.ToolTipText := 'Total number of items';
  // 
  // bindingNavigatorDeleteItem
  // 
  self.bindingNavigatorDeleteItem.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
  self.bindingNavigatorDeleteItem.Image := (resources.GetObject('bindingNavigatorDeleteItem.Image') as System.Drawing.Image);
  self.bindingNavigatorDeleteItem.Name := 'bindingNavigatorDeleteItem';
  self.bindingNavigatorDeleteItem.RightToLeftAutoMirrorImage := true;
  self.bindingNavigatorDeleteItem.Size := new System.Drawing.Size(23, 22);
  self.bindingNavigatorDeleteItem.Text := 'Delete';
  // 
  // bindingNavigatorMoveFirstItem
  // 
  self.bindingNavigatorMoveFirstItem.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
  self.bindingNavigatorMoveFirstItem.Image := (resources.GetObject('bindingNavigatorMoveFirstItem.Image') as System.Drawing.Image);
  self.bindingNavigatorMoveFirstItem.Name := 'bindingNavigatorMoveFirstItem';
  self.bindingNavigatorMoveFirstItem.RightToLeftAutoMirrorImage := true;
  self.bindingNavigatorMoveFirstItem.Size := new System.Drawing.Size(23, 22);
  self.bindingNavigatorMoveFirstItem.Text := 'Move first';
  // 
  // bindingNavigatorMovePreviousItem
  // 
  self.bindingNavigatorMovePreviousItem.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
  self.bindingNavigatorMovePreviousItem.Image := (resources.GetObject('bindingNavigatorMovePreviousItem.Image') as System.Drawing.Image);
  self.bindingNavigatorMovePreviousItem.Name := 'bindingNavigatorMovePreviousItem';
  self.bindingNavigatorMovePreviousItem.RightToLeftAutoMirrorImage := true;
  self.bindingNavigatorMovePreviousItem.Size := new System.Drawing.Size(23, 22);
  self.bindingNavigatorMovePreviousItem.Text := 'Move previous';
  // 
  // bindingNavigatorSeparator
  // 
  self.bindingNavigatorSeparator.Name := 'bindingNavigatorSeparator';
  self.bindingNavigatorSeparator.Size := new System.Drawing.Size(6, 25);
  // 
  // bindingNavigatorPositionItem
  // 
  self.bindingNavigatorPositionItem.AccessibleName := 'Position';
  self.bindingNavigatorPositionItem.AutoSize := false;
  self.bindingNavigatorPositionItem.Name := 'bindingNavigatorPositionItem';
  self.bindingNavigatorPositionItem.Size := new System.Drawing.Size(50, 21);
  self.bindingNavigatorPositionItem.Text := '0';
  self.bindingNavigatorPositionItem.ToolTipText := 'Current position';
  // 
  // bindingNavigatorSeparator1
  // 
  self.bindingNavigatorSeparator1.Name := 'bindingNavigatorSeparator1';
  self.bindingNavigatorSeparator1.Size := new System.Drawing.Size(6, 25);
  // 
  // bindingNavigatorMoveNextItem
  // 
  self.bindingNavigatorMoveNextItem.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
  self.bindingNavigatorMoveNextItem.Image := (resources.GetObject('bindingNavigatorMoveNextItem.Image') as System.Drawing.Image);
  self.bindingNavigatorMoveNextItem.Name := 'bindingNavigatorMoveNextItem';
  self.bindingNavigatorMoveNextItem.RightToLeftAutoMirrorImage := true;
  self.bindingNavigatorMoveNextItem.Size := new System.Drawing.Size(23, 22);
  self.bindingNavigatorMoveNextItem.Text := 'Move next';
  // 
  // bindingNavigatorMoveLastItem
  // 
  self.bindingNavigatorMoveLastItem.DisplayStyle := System.Windows.Forms.ToolStripItemDisplayStyle.Image;
  self.bindingNavigatorMoveLastItem.Image := (resources.GetObject('bindingNavigatorMoveLastItem.Image') as System.Drawing.Image);
  self.bindingNavigatorMoveLastItem.Name := 'bindingNavigatorMoveLastItem';
  self.bindingNavigatorMoveLastItem.RightToLeftAutoMirrorImage := true;
  self.bindingNavigatorMoveLastItem.Size := new System.Drawing.Size(23, 22);
  self.bindingNavigatorMoveLastItem.Text := 'Move last';
  // 
  // bindingNavigatorSeparator2
  // 
  self.bindingNavigatorSeparator2.Name := 'bindingNavigatorSeparator2';
  self.bindingNavigatorSeparator2.Size := new System.Drawing.Size(6, 25);
  // 
  // bindingSource1
  // 
  self.bindingSource1.DataMember := 'Emails';
  self.bindingSource1.DataSource := self.localData1;
  // 
  // localData1
  // 
  self.localData1.DataSetName := 'LocalData';
  self.localData1.SchemaSerializationMode := System.Data.SchemaSerializationMode.IncludeSchema;
  // 
  // iDDataGridViewTextBoxColumn
  // 
  self.iDDataGridViewTextBoxColumn.AutoSizeMode := System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
  self.iDDataGridViewTextBoxColumn.DataPropertyName := 'ID';
  self.iDDataGridViewTextBoxColumn.HeaderText := 'ID';
  self.iDDataGridViewTextBoxColumn.Name := 'iDDataGridViewTextBoxColumn';
  self.iDDataGridViewTextBoxColumn.ReadOnly := true;
  self.iDDataGridViewTextBoxColumn.Width := 50;
  // 
  // nameDataGridViewTextBoxColumn
  // 
  self.nameDataGridViewTextBoxColumn.AutoSizeMode := System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
  self.nameDataGridViewTextBoxColumn.DataPropertyName := 'Name';
  self.nameDataGridViewTextBoxColumn.HeaderText := 'Name';
  self.nameDataGridViewTextBoxColumn.Name := 'nameDataGridViewTextBoxColumn';
  // 
  // emailDataGridViewTextBoxColumn
  // 
  self.emailDataGridViewTextBoxColumn.AutoSizeMode := System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
  self.emailDataGridViewTextBoxColumn.DataPropertyName := 'Email';
  self.emailDataGridViewTextBoxColumn.HeaderText := 'Email';
  self.emailDataGridViewTextBoxColumn.Name := 'emailDataGridViewTextBoxColumn';
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(596, 327);
  self.Controls.Add(self.dataGridView1);
  self.Controls.Add(self.bindingNavigator1);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.Name := 'MainForm';
  self.Text := 'Local XML Data Store Sample';
  self.FormClosing += new System.Windows.Forms.FormClosingEventHandler(@self.MainForm_FormClosing);
  (self.dataGridView1 as System.ComponentModel.ISupportInitialize).EndInit();
  (self.bindingNavigator1 as System.ComponentModel.ISupportInitialize).EndInit();
  self.bindingNavigator1.ResumeLayout(false);
  self.bindingNavigator1.PerformLayout();
  (self.bindingSource1 as System.ComponentModel.ISupportInitialize).EndInit();
  (self.localData1 as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

method MainForm.MainForm_FormClosing(sender: System.Object; e: System.Windows.Forms.FormClosingEventArgs);
begin
  localData1.WriteXml(fDataFileName);
end;

end.