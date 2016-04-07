namespace LinqToSQL;

interface

uses
  System.Drawing,
  System.Collections,
  System.Collections.Generic,
  System.Linq,
  System.Data.Linq,
  System.Data.Linq.Mapping,
  System.Windows.Forms,
  System.ComponentModel;

type
  /// <summary>
  /// Summary description for Form1.
  /// </summary>
  MainForm = partial class(System.Windows.Forms.Form)
  private
    method btnSelectDBFile_Click(sender: System.Object; e: System.EventArgs);
    method btnExecuteSELECT_Click(sender: System.Object; e: System.EventArgs);
    method btnExecuteJOIN_Click(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(aDisposing: Boolean); override;
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

  //
  // TODO: Add any constructor code after InitializeComponent call
  //
end;

method MainForm.Dispose(aDisposing: Boolean);
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

method MainForm.btnSelectDBFile_Click(sender: System.Object; e: System.EventArgs);
begin
  if openFileDialog.ShowDialog = DialogResult.OK then begin
     tbDatabase.Text := openFileDialog.FileName;
  end;
end;

method MainForm.btnExecuteSELECT_Click(sender: System.Object; e: System.EventArgs);
var
 path : String := System.IO.Path.GetFullPath(tbDatabase.Text);
 db : DataContext := new DataContext(path);
begin
  Cursor := Cursors.WaitCursor;
  try
    var contacts := from contact in db.GetTable<Contact>()
                 where contact.ModifiedDate.Year = 2001
                 select contact;

    dataGridView.DataSource := contacts;
  finally
    Cursor := Cursors.Default;
  end;
end;

method MainForm.btnExecuteJOIN_Click(sender: System.Object; e: System.EventArgs);
 var
 path : String := System.IO.Path.GetFullPath(tbDatabase.Text);
 db : DataContext := new DataContext(path);
 cats : Table<Category> := db.GetTable<Category>();
 subcats : Table<SubCategory> := db.GetTable<SubCategory>();
begin
  Cursor := Cursors.WaitCursor;
  try
    var query := from cat in cats join subcat in subcats
              on cat.CategoryID equals subcat.CategoryID
              order by cat.Name
              select new class ( cat.Name, subcat.SubCatName);


    dataGridView.DataSource := query;
  finally
    Cursor := Cursors.Default;
  end;
end;

end.