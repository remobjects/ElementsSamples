namespace HorseRace;

interface

uses
  System.Windows.Forms, 
  System.Drawing;

type
  HorseUIUpdateDelegate = delegate(aPictureBox : PictureBox; anIncrement : integer);
  
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    panel2: System.Windows.Forms.Panel;
    panel3: System.Windows.Forms.Panel;
    panel1: System.Windows.Forms.Panel;
    Horse1: System.Windows.Forms.PictureBox;
    Horse2: System.Windows.Forms.PictureBox;
    Horse3: System.Windows.Forms.PictureBox;
    bStartRace: System.Windows.Forms.Button;
    components: System.ComponentModel.Container := nil;
    pictureBox1: System.Windows.Forms.PictureBox;
    method bStartRace_Click(sender: System.Object; e: System.EventArgs);
    method MainForm_Load(sender: System.Object; e: System.EventArgs);
    method InitializeComponent;
  {$ENDREGION}
  private
    const
      TotalHorses: integer = 3;
    
  protected
    fFirstHorse: integer;
    
    method Dispose(aDisposing: boolean); override;

    method DoHorseUIUpdate(aPictureBox : PictureBox; anIncrement : integer); 
    method SetFirstHorse(Value : integer); locked; // Thread safe
  public
    constructor;
    class method Main;
    
    method FindControl(aParent: Control; aName: string): Control;
    method Race(LaneNumber: integer); async; // Asynchronous method that will execute in its own thread
    
    property FirstHorse: integer read fFirstHorse write SetFirstHorse;
    class RandomGen: Random := new Random();
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

method MainForm.Dispose(aDisposing: boolean);
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

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.Horse1 := new System.Windows.Forms.PictureBox();
  self.Horse2 := new System.Windows.Forms.PictureBox();
  self.Horse3 := new System.Windows.Forms.PictureBox();
  self.bStartRace := new System.Windows.Forms.Button();
  self.panel1 := new System.Windows.Forms.Panel();
  self.panel2 := new System.Windows.Forms.Panel();
  self.panel3 := new System.Windows.Forms.Panel();
  self.pictureBox1 := new System.Windows.Forms.PictureBox();
  (self.Horse1 as System.ComponentModel.ISupportInitialize).BeginInit();
  (self.Horse2 as System.ComponentModel.ISupportInitialize).BeginInit();
  (self.Horse3 as System.ComponentModel.ISupportInitialize).BeginInit();
  (self.pictureBox1 as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // Horse1
  // 
  self.Horse1.Image := (resources.GetObject('Horse1.Image') as System.Drawing.Image);
  self.Horse1.Location := new System.Drawing.Point(16, 77);
  self.Horse1.Name := 'Horse1';
  self.Horse1.Size := new System.Drawing.Size(95, 72);
  self.Horse1.TabIndex := 0;
  self.Horse1.TabStop := false;
  // 
  // Horse2
  // 
  self.Horse2.Image := (resources.GetObject('Horse2.Image') as System.Drawing.Image);
  self.Horse2.Location := new System.Drawing.Point(16, 181);
  self.Horse2.Name := 'Horse2';
  self.Horse2.Size := new System.Drawing.Size(95, 72);
  self.Horse2.TabIndex := 1;
  self.Horse2.TabStop := false;
  // 
  // Horse3
  // 
  self.Horse3.Image := (resources.GetObject('Horse3.Image') as System.Drawing.Image);
  self.Horse3.Location := new System.Drawing.Point(16, 285);
  self.Horse3.Name := 'Horse3';
  self.Horse3.Size := new System.Drawing.Size(95, 72);
  self.Horse3.TabIndex := 3;
  self.Horse3.TabStop := false;
  // 
  // bStartRace
  // 
  self.bStartRace.ImageAlign := System.Drawing.ContentAlignment.MiddleRight;
  self.bStartRace.Location := new System.Drawing.Point(16, 12);
  self.bStartRace.Name := 'bStartRace';
  self.bStartRace.Size := new System.Drawing.Size(120, 23);
  self.bStartRace.TabIndex := 7;
  self.bStartRace.Text := 'Start Race';
  self.bStartRace.Click += new System.EventHandler(@self.bStartRace_Click);
  // 
  // panel1
  // 
  self.panel1.Anchor := (((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.panel1.BackColor := System.Drawing.Color.FromArgb(((0 as System.Byte) as System.Int32), ((192 as System.Byte) as System.Int32), ((0 as System.Byte) as System.Int32));
  self.panel1.BorderStyle := System.Windows.Forms.BorderStyle.FixedSingle;
  self.panel1.Location := new System.Drawing.Point(16, 149);
  self.panel1.Name := 'panel1';
  self.panel1.Size := new System.Drawing.Size(488, 16);
  self.panel1.TabIndex := 8;
  // 
  // panel2
  // 
  self.panel2.Anchor := (((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.panel2.BackColor := System.Drawing.Color.FromArgb(((0 as System.Byte) as System.Int32), ((192 as System.Byte) as System.Int32), ((0 as System.Byte) as System.Int32));
  self.panel2.BorderStyle := System.Windows.Forms.BorderStyle.FixedSingle;
  self.panel2.Location := new System.Drawing.Point(16, 253);
  self.panel2.Name := 'panel2';
  self.panel2.Size := new System.Drawing.Size(488, 16);
  self.panel2.TabIndex := 9;
  // 
  // panel3
  // 
  self.panel3.Anchor := (((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.panel3.BackColor := System.Drawing.Color.FromArgb(((0 as System.Byte) as System.Int32), ((192 as System.Byte) as System.Int32), ((0 as System.Byte) as System.Int32));
  self.panel3.BorderStyle := System.Windows.Forms.BorderStyle.FixedSingle;
  self.panel3.Location := new System.Drawing.Point(16, 357);
  self.panel3.Name := 'panel3';
  self.panel3.Size := new System.Drawing.Size(488, 16);
  self.panel3.TabIndex := 10;
  // 
  // pictureBox1
  // 
  self.pictureBox1.Image := (resources.GetObject('pictureBox1.Image') as System.Drawing.Image);
  self.pictureBox1.InitialImage := (resources.GetObject('pictureBox1.InitialImage') as System.Drawing.Image);
  self.pictureBox1.Location := new System.Drawing.Point(446, 12);
  self.pictureBox1.Name := 'pictureBox1';
  self.pictureBox1.Size := new System.Drawing.Size(62, 62);
  self.pictureBox1.SizeMode := System.Windows.Forms.PictureBoxSizeMode.StretchImage;
  self.pictureBox1.TabIndex := 11;
  self.pictureBox1.TabStop := false;
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(520, 406);
  self.Controls.Add(self.pictureBox1);
  self.Controls.Add(self.panel3);
  self.Controls.Add(self.panel2);
  self.Controls.Add(self.panel1);
  self.Controls.Add(self.bStartRace);
  self.Controls.Add(self.Horse1);
  self.Controls.Add(self.Horse2);
  self.Controls.Add(self.Horse3);
  self.ForeColor := System.Drawing.SystemColors.ControlText;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.Name := 'MainForm';
  self.Text := 'Horse Race Sample';
  self.Load += new System.EventHandler(@self.MainForm_Load);
  (self.Horse1 as System.ComponentModel.ISupportInitialize).EndInit();
  (self.Horse2 as System.ComponentModel.ISupportInitialize).EndInit();
  (self.Horse3 as System.ComponentModel.ISupportInitialize).EndInit();
  (self.pictureBox1 as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
end;
{$ENDREGION}

{$REGION Application Entry Point}
[STAThread]
class method MainForm.Main;
begin
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
begin
  { Notice the use of the "matching" keyword in this for-each block.
    We loop through all the Controls in the form that are of PictureBox type. }
  for each matching picture: PictureBox in Controls do 
    (picture.Image as Bitmap).MakeTransparent(Color.Red);
end;

method MainForm.bStartRace_Click(sender: System.Object; e: System.EventArgs);
begin
  fFirstHorse := 0;
  { Since the Race method was marked "async", the following loop will
    terminate before the horses finish racing }    
  for i: integer := 1 to TotalHorses do 
    Race(i);

  { We need to wait until there's a winner before showing the dialog }
  while (FirstHorse=0) do 
    Application.DoEvents;
  
  { Displays the winner }
  MessageBox.Show('Horse '+FirstHorse.ToString+' won the race!');
end;

method MainForm.DoHorseUIUpdate(aPictureBox : PictureBox; anIncrement : integer); 
begin
  if (anIncrement<=0) 
    then aPictureBox.Left := 8
    else aPictureBox.Left := aPictureBox.Left+anIncrement;
end;

method MainForm.Race(LaneNumber: integer); 
var horse: PictureBox;
    
begin
  { We find the right PictureBox }
  horse := FindControl(Self, 'Horse'+LaneNumber.ToString) as PictureBox;
  if (horse=NIL) then raise new Exception('No such lane!');
    
  { The race code }
  horse.Invoke(new HorseUIUpdateDelegate(@DoHorseUIUpdate), [horse, 0]);
  
  while (horse.Left<horse.Parent.Width-horse.Width-20) do begin
    { Control access needs to be synchronized }
    horse.BeginInvoke(new HorseUIUpdateDelegate(@DoHorseUIUpdate), [horse, 10]);
    System.Threading.Thread.Sleep(RandomGen.Next(10, 300));
  end;
  
  { The following assignment is thread safe, because of the "locked" directive
    used in the declaration of SetFirstHorse above }
  if (FirstHorse = 0) then 
    FirstHorse := LaneNumber;
end;

method MainForm.FindControl(aParent: Control; aName: string): Control; 
begin
  for each matching tmpcontrol: Control in aParent.Controls do begin
    if (String.Compare(tmpcontrol.Name, aName, TRUE)=0) then begin
      { Exits returning tmpcontrol as value. This is equivalent to
          
          [..]
          begin
            result := tmpcontrol;
            exit;
          end;
      }
      exit(tmpcontrol);
    end
    else begin
      { Scans the control recursively }
      result := FindControl(tmpcontrol, aName);
      if (result <> NIL) then exit;
    end;
  end;
end;

method MainForm.SetFirstHorse(Value: integer); 
{ Safety checks to ensure this method is always called with a proper value. }
{ Note how we make use of the new "between" operator to compare both upper 
  and lower bounds at the same time. }
require
  0 < Value <= TotalHorses;
begin
  fFirstHorse := Value;
end;

end.
