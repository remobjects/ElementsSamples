namespace Basic_WebAssembly_GUI_App;

uses
  RemObjects.Elements.RTL.Delphi, RemObjects.Elements.RTL.Delphi.VCL;

type
  [Export]
  Program = public class
  public

    method HelloWorld;
    begin
      Application := new TApplication(nil);
      Application.Initialize;
      Application.Run;

      // Create form
      var lForm := new TForm(nil);
      lForm.Width := 800;
      // we can display the form in an existing div element. If Show parameter is nil, a new div is created
      lForm.Show(nil);

      var lTopLabel := new TLabel(lForm);
      lTopLabel.Left := 1;
      lTopLabel.Parent := lForm;
      lTopLabel.Caption := 'Write the item caption on the edit and press Add New button to add to ListBox:';

      var lButton := new TButton(lForm);
      lButton.Left := 50;
      lButton.Top := 50;
      lButton.Caption := 'Add New';
      lButton.Parent := lForm;

      var lEdit := new TEdit(lForm);
      lEdit.Left := 150;
      lEdit.Top := 50;
      lEdit.Parent := lForm;

      var lListBox := new TListBox(lForm);
      lListBox.Left := 350;
      lListBox.Top := 50;
      lListBox.Parent := lForm;
      lListBox.Width := 250;
      lListBox.MultiSelect := true;

      lButton.OnClick := () -> begin lListBox.Items.Add(lEdit.Text); end;

      var lChangeLabel := new TLabel(lForm);
      lChangeLabel.Top := 165;
      lChangeLabel.Parent := lForm;
      lChangeLabel.Caption := 'Press button to change label font:';

      var lChangeButton := new TButton(lForm);
      lChangeButton.Left := 50;
      lChangeButton.Top := 200;
      lChangeButton.Caption := 'Change font';
      lChangeButton.Parent := lForm;

      var lLabel := new TLabel(lForm);
      lLabel.Left := 150;
      lLabel.Top := 200;
      lLabel.Caption := 'Sample text!';
      lLabel.Parent := lForm;

      lChangeButton.OnClick := () -> begin lLabel.Font.Name := 'Verdana'; lLabel.Font.Size := 24; end;

      var lMemo := new TMemo(lForm);
      lMemo.Left := 50;
      lMemo.Top := 300;
      lMemo.Width := 250;
      lMemo.Height := 150;
      lMemo.Parent := lForm;

      var lMemoButton := new TButton(lForm);
      lMemoButton.Left := 350;
      lMemoButton.Top := 325;
      lMemoButton.Caption := 'Add text';
      lMemoButton.Parent := lForm;
      var lList := TStringList.Create;
      lList.Add('one line');
      lList.Add('another one');
      lMemoButton.OnClick := () -> begin lMemo.Lines.AddStrings(lList); end;

      var lDisplayButton := new TButton(lForm);
      lDisplayButton.Top := lMemoButton.Top;
      lDisplayButton.Left := 450;
      lDisplayButton.Caption := 'Show memo text';
      lDisplayButton.Parent := lForm;
      lDisplayButton.OnClick := ()-> begin ShowMessage(lMemo.Lines.Text); end;
    end;
  end;

end.