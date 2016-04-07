namespace Steema.TeeChart.Samples.Oxygene;

interface

uses
  System.Windows.Forms, Steema.TeeChart, Steema.TeeChart.Styles;

type
  MainForm = class(System.Windows.Forms.Form)
  private
    Chart1 : TChart;
  public
    constructor;
    class method Main;
  end;

implementation

constructor MainForm;
begin
  Width:=400;
  Height:=250;
  FormBorderStyle := FormBorderStyle.FixedDialog;
  MaximizeBox := false;

  Chart1:= new TChart;
  Chart1.Parent := Self;
  Chart1.SetBounds( 10, 50, Width - 30, Height - 80 );

  Chart1.Series.Add( new Bar ).FillSampleValues;
  Chart1[0].ColorEach:=True;

  Text := 'TeeChart.Net Lite, WinForms Oxygene Application';
end;

class method MainForm.Main;
var
  lForm: System.Windows.Forms.Form;
begin
  Application.EnableVisualStyles();
  try
    lForm := new MainForm();
    Application.Run(lForm);
  except
    on E: Exception do begin
      MessageBox.Show(E.Message);
    end;
  end;
end;

end.
