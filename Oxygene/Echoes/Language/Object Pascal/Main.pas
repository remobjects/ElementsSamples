namespace ObjectPascal;

interface

uses
  System.Windows.Forms,
  System.Drawing,
  System.Text,
  Oxygene.Samples.SampleClasses; { <-- Contains the classes used in this example }

type
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    bArrays: System.Windows.Forms.Button;
    bTryBlock: System.Windows.Forms.Button;
    bAddress: System.Windows.Forms.Button;
    bExtendedCase: System.Windows.Forms.Button;
    bUsePersonCollection: System.Windows.Forms.Button;
    bCreatePersonSSN: System.Windows.Forms.Button;
    components: System.ComponentModel.Container := nil;
    method bInlineArrays_Click(sender: System.Object; e: System.EventArgs);
    method bTryBlock_Click(sender: System.Object; e: System.EventArgs);
    method bAddress_Click(sender: System.Object; e: System.EventArgs);
    method bExtendedCase_Click(sender: System.Object; e: System.EventArgs);
    method bUsePersonCollection_Click(sender: System.Object; e: System.EventArgs);
    method bCreatePerson_Click(sender: System.Object; e: System.EventArgs);
    method InitializeComponent;
  {$ENDREGION}
  protected
    method Dispose(aDisposing: Boolean); override;
  const
    CRLF = #13#10;
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

method MainForm.Dispose(aDisposing: Boolean);
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
  self.bCreatePersonSSN := new System.Windows.Forms.Button();
  self.bUsePersonCollection := new System.Windows.Forms.Button();
  self.bExtendedCase := new System.Windows.Forms.Button();
  self.bAddress := new System.Windows.Forms.Button();
  self.bTryBlock := new System.Windows.Forms.Button();
  self.bArrays := new System.Windows.Forms.Button();
  self.SuspendLayout();
  //
  // bCreatePersonSSN
  //
  self.bCreatePersonSSN.Location := new System.Drawing.Point(19, 17);
  self.bCreatePersonSSN.Name := 'bCreatePersonSSN';
  self.bCreatePersonSSN.Size := new System.Drawing.Size(192, 23);
  self.bCreatePersonSSN.TabIndex := 0;
  self.bCreatePersonSSN.Text := 'Create Person and Display SSN';
  self.bCreatePersonSSN.Click += new System.EventHandler(@self.bCreatePerson_Click);
  //
  // bUsePersonCollection
  //
  self.bUsePersonCollection.Location := new System.Drawing.Point(19, 49);
  self.bUsePersonCollection.Name := 'bUsePersonCollection';
  self.bUsePersonCollection.Size := new System.Drawing.Size(192, 23);
  self.bUsePersonCollection.TabIndex := 1;
  self.bUsePersonCollection.Text := 'Use Person Collection';
  self.bUsePersonCollection.Click += new System.EventHandler(@self.bUsePersonCollection_Click);
  //
  // bExtendedCase
  //
  self.bExtendedCase.Location := new System.Drawing.Point(19, 81);
  self.bExtendedCase.Name := 'bExtendedCase';
  self.bExtendedCase.Size := new System.Drawing.Size(192, 23);
  self.bExtendedCase.TabIndex := 2;
  self.bExtendedCase.Text := 'Extended Case';
  self.bExtendedCase.Click += new System.EventHandler(@self.bExtendedCase_Click);
  //
  // bAddress
  //
  self.bAddress.Location := new System.Drawing.Point(19, 113);
  self.bAddress.Name := 'bAddress';
  self.bAddress.Size := new System.Drawing.Size(192, 23);
  self.bAddress.TabIndex := 3;
  self.bAddress.Text := 'Address';
  self.bAddress.Click += new System.EventHandler(@self.bAddress_Click);
  //
  // bTryBlock
  //
  self.bTryBlock.Location := new System.Drawing.Point(19, 145);
  self.bTryBlock.Name := 'bTryBlock';
  self.bTryBlock.Size := new System.Drawing.Size(192, 23);
  self.bTryBlock.TabIndex := 4;
  self.bTryBlock.Text := 'Try/Except/Finally';
  self.bTryBlock.Click += new System.EventHandler(@self.bTryBlock_Click);
  //
  // bArrays
  //
  self.bArrays.Location := new System.Drawing.Point(19, 177);
  self.bArrays.Name := 'bArrays';
  self.bArrays.Size := new System.Drawing.Size(192, 23);
  self.bArrays.TabIndex := 5;
  self.bArrays.Text := 'Arrays';
  self.bArrays.Click += new System.EventHandler(@self.bInlineArrays_Click);
  //
  // MainForm
  //
  self.ClientSize := new System.Drawing.Size(230, 216);
  self.Controls.Add(self.bArrays);
  self.Controls.Add(self.bTryBlock);
  self.Controls.Add(self.bAddress);
  self.Controls.Add(self.bExtendedCase);
  self.Controls.Add(self.bUsePersonCollection);
  self.Controls.Add(self.bCreatePersonSSN);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'ObjectPascal Sample';
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
    on Ez: Exception do begin
      MessageBox.Show(Ez.Message);
    end;
  end;
end;
{$ENDREGION}

method MainForm.bCreatePerson_Click(sender: System.Object; e: System.EventArgs);
var
  somebody : Person;
begin
  { Creates an instance of Person.
    Try to change the age to a negative number to see how the class invariants generate
    an error }
  somebody := new Person('John Smith', 30, Gender.Male);
  MessageBox.Show('The SSN for '+somebody.Name+' is '+somebody.GenerateSSN);

  { The last two assignments below violate the Person's class contracts.
    Uncomment them to see assertion error(s) generated. }
  somebody.NickName := 'The Man';
  //somebody.NickName := '';
  //somebody.Age := -1;
end;

method MainForm.bUsePersonCollection_Click(sender: System.Object; e: System.EventArgs);
var
  john, mary: Person;
    persons : PersonCollection;
    sb : StringBuilder := new StringBuilder;
begin
  { Creates the collection }
  persons := new PersonCollection();

  { Creates two persons and adds them to the strongly typed collection }
  john := persons.Add('John Smith', 32, Gender.Male);

  mary := new Person('Mary Bloody', 67, Gender.Female);
  persons.Add(mary);

  { Loops through the items in the collection and prepares a list of names.
    Notice how the "person" variable is not declared in the var section above
    and is not recognized outside this loop. }
  sb.Append('--- Using the "for each" loop ---'+CRLF);
  for each person : Person in persons do
    sb.Append(person.Name+CRLF);

  { Uses the property Persons using both default indexing mechanisms (which are overloaded) }
  sb.Append(CRLF);
  sb.Append('--- Using indexes ---'+CRLF);

  mary := persons[1];
  sb.Append(mary.Name+CRLF);

  john := persons['John Smith'];
  sb.Append(john.Name+CRLF);

  { Finally displays the string we built }
  MessageBox.Show(sb.ToString);
end;

method MainForm.bExtendedCase_Click(sender: System.Object; e: System.EventArgs);
const
  msg_Person = 'You chose the Person class: no salary provided';
  msg_Employee = 'You chose the Employee class: we can read the salary';
var
  somebody : Person;
  theclass : PersonClass;
  msg : String;
  salary : Double;
begin
  case MessageBox.Show('Do you want to create an Employee?',
                       'Select Class Type',
                       MessageBoxButtons.YesNo) of
    DialogResult.No: theclass := Person;
    DialogResult.Yes: theclass := Employee;
  end;

  somebody := theclass.New('Richard Torris', 39, Gender.Male);

  // Case with types
  case somebody type of
    Employee: msg := msg_Employee;
    Person: msg := msg_Person;
  end;
  MessageBox.Show(msg);

  // Case with strings
  case msg of
    msg_Person: salary := -1;
    else salary := Employee(somebody).Salary
  end;

  // Alternative approach using IIF
  // salary := iif(msg=msg_Person, -1, Employee(somebody).Salary);

  MessageBox.Show(salary.ToString)
end;

method MainForm.bAddress_Click(sender: System.Object; e: System.EventArgs);
var
  somebody: Person;
begin
  { Notice the use of UNICODE letters here }
  somebody := new Person('Jörg Ackehörst', 25, Gender.Male);

  { If you take a look at the Person class, you will notice how Address
    is initialized at the property declaration, rather than needing special
    code in the constructor. The only reason we created a specialized constructor
    for Person is to avoid having to set Name, Age and Sex with 3 different lines
    of code. }
  somebody.Address.City := 'Dören';
  somebody.Address.Street := 'Königsallee 211';
  somebody.Address.Zip := '14323';

  MessageBox.Show(somebody.Name+CRLF+
                  somebody.Address.City+CRLF+
                  somebody.Address.Street+CRLF+
                  somebody.Address.Zip);
end;

method MainForm.bTryBlock_Click(sender: System.Object; e: System.EventArgs);
begin
  try
    if (MessageBox.Show('Do you want to raise an exception?', 'Raise Exception',
                         MessageBoxButtons.YesNo)=DialogResult.Yes) then
      raise new ECustomException('This is a custom exception');
  except
    on Ez:ECustomException do
      MessageBox.Show('Caught a custom exception saying "'+Ez.Message+'"');
  finally
    MessageBox.Show('Finally we got here');
  end;
end;

method MainForm.bInlineArrays_Click(sender: System.Object; e: System.EventArgs);
var
  intarray: array of Integer := [0, 1, 2, 3];
  s: String;
  dynarray: array[3..] of Integer;
  strarray: array of String;
begin
  { Fixed length array }
  for each int : Integer in intarray do
    s := s+int.ToString+' ';

  MessageBox.Show('Fixed length array: '+s);

  { Dynamic array - Notice how its first element starts from 3 rather than 0 }
  s := '';
  dynarray := new Integer[length(intarray)];
  for int: Integer := 0 to length(intarray)-1 do begin
    dynarray[int+3] := intarray[int];
    s := s+int.ToString+' ';
  end;

  MessageBox.Show('Dynamic array: '+s);

  { Inline array assignment }
  s := '';
  strarray := ['Alex', 'John', 'Mary'];
  for each mystr: String in strarray do
    s := s+mystr+' ';

  MessageBox.Show('Inline array: '+s);
end;

end.