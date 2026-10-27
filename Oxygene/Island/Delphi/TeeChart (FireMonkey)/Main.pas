// Positive sample: use the TeeChart shipped with Delphi through its imported FireMonkey packages.
namespace TeeChartSample;

uses
  System.Classes,
  FMX.Forms,
  FMXTee.Chart,
  FMXTee.Series;

type
  TChartForm = public class(TForm)
  published
    Chart1: TChart;
    BarSeries1: TBarSeries;
    method FormCreate(Sender: TObject);
    begin
      BarSeries1.FillSampleValues(5);
      BarSeries1.ColorEachPoint := true;
    end;
  end;

  Program = class
  public
    class method Main;
    begin
      Application.Initialize;
      var lForm: TChartForm;
      Application.CreateForm(TChartForm, var lForm);
      Application.Run;
    end;
  end;
end.
