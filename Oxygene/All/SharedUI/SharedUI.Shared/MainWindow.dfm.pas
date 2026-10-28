namespace SharedUI.Shared;
{$IF VCL}

uses System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls;

type
  // VCL owns this Delphi form. The application retains the shared Island controller.
  MainWindow = public class(TForm)
  published

    field ValueAEdit: TEdit;
    field ValueBEdit: TEdit;
    field ResultLabel: TLabel;
    field CalculateButton: TButton;
    field ValueALabel: TLabel;
    field ValueBLabel: TLabel;
    field ExplanationLabel: TLabel;

    method ValueAChanged(aSender: TObject);
    begin
      controller:valueA := ValueAEdit.Text;
    end;

    method ValueBChanged(aSender: TObject);
    begin
      controller:valueB := ValueBEdit.Text;
    end;

    method CalculateClick(aSender: TObject);
    begin
      // The button forwards to the shared action; no calculation lives in this form.
      controller.calculateResult(nil);
    end;

  public

    property controller: MainWindowController;

  end;

{$ENDIF}
end.
