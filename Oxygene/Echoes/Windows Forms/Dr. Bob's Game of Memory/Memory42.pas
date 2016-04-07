namespace Memory42;

// Memory game by Bob Swart (aka Dr.Bob - www.drbob42.com)

interface

uses
  System.Windows.Forms,
  System.Drawing;

type
  DontDesign = class(Object);

  MemoryForm = class(System.Windows.Forms.Form)
  const
    Caption = 'Sharpen your mind: Dr. Bob''s Game of Memory for .NET ({0})';
    MaxX = 6;
    MaxY = 4;
  public
    constructor;
    class method Main;
  protected
    method Buttons_Click(sender: System.Object; e: System.EventArgs);
  private
    Turns: Integer;
    First: Boolean; // first or second button was clicked?
    Buttons: array[1..MaxX,1..MaxY] of System.Windows.Forms.Button;
  end;

implementation

uses
  System.Threading; // Sleep

constructor MemoryForm;
var
  i,j,Tag: Integer;
  X1,X2,Y1,Y2: Integer;
  Rand: Random;
begin
  inherited constructor;
  FormBorderStyle := FormBorderStyle.FixedDialog;
  MaximizeBox := false;

  Rand := new Random;
  Turns := 0;
  Text := String.Format(Caption, '-');
  First := True;
  Size := new System.Drawing.Size(612, 436);
  for i:=1 to MaxX do begin
    for j:=1 to MaxY do begin
      Buttons[i,j] := new Button;
      Buttons[i,j].Location := new Point(6 + (600 div MaxX) * (i-1), 6 + (400 div MaxY) * (j-1));
      Buttons[i,j].Size := new System.Drawing.Size((600 div MaxX) - 8,(400 div MaxY) - 8);
      Buttons[i,j].Tag := System.Object(1 + (j-1) * MaxX + (i-1) div 2);
      Buttons[i,j].Text := '?';
      Buttons[i,j].Font := new System.Drawing.Font('Comic Sans MS', 24);
      Buttons[i,j].Click += Buttons_Click;
      Controls.Add(Buttons[i,j])
    end
  end;
  for i:=1 to 42 do begin
    X1 := 1+Rand.Next(MaxX);
    X2 := 1+Rand.Next(MaxX);
    Y1 := 1+Rand.Next(MaxY);
    Y2 := 1+Rand.Next(MaxY);
    Tag := Convert.ToInt16(Buttons[X1,Y1].Tag);
    Buttons[X1,Y1].Tag := Buttons[X2,Y2].Tag;
    Buttons[X2,Y2].Tag := System.Object(Tag)
  end;
end;

method MemoryForm.Buttons_Click(sender: System.Object; e: System.EventArgs);
var
  i,j: Integer;
begin
  if First then begin
    First := False;
    Inc(Turns);
    Text := String.Format(Caption, Turns);
    Tag := (Sender as Button).Tag;
    (Sender as Button).Text := Tag.ToString
  end
  else { second button } if (Sender as Button).Text = '?' then begin { not used before }
    First := True; 
    (Sender as Button).Text := (Sender as Button).Tag.ToString;
    Update;
    if (Sender as Button).Tag.ToString = Tag.ToString then begin
      { the same }
      for i:=1 to MaxX do
        for j:=1 to MaxY do
          if Buttons[i,j].Tag.ToString = Tag.ToString then begin
            Buttons[i,j].Enabled := False;
            Buttons[i,j].Text := '['+Tag.ToString+']'
          end
    end
    else begin { not the same; hide again }
      Thread.Sleep(1000);
      for i:=1 to MaxX do
        for j:=1 to MaxY do
          if Buttons[i,j].Enabled then Buttons[i,j].Text := '?'
    end
  end
end;

class method MemoryForm.Main;
begin
  try
    Application.Run(new MemoryForm);
  except
    on E: Exception do
      MessageBox.Show(E.Message);
  end;
end;

end.
