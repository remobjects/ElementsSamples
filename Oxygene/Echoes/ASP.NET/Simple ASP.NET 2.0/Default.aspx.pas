namespace;

interface

uses
  System,
  System.Data,
  System.Configuration,
  System.Web,
  System.Web.Security,
  System.Web.UI,
  System.Web.UI.WebControls,
  System.Web.UI.WebControls.WebParts,
  System.Web.UI.HtmlControls;

type
  DefaultPage = public partial class(System.Web.UI.Page)
  protected
    method btnRefresh_Click(sender: System.Object; e: System.EventArgs);
  end;

implementation

method DefaultPage.btnRefresh_Click(sender: System.Object; e: System.EventArgs);
begin
  try
    var lValue: Double := Double.Parse(edInput.Text, System.Globalization.NumberFormatInfo.InvariantInfo);
    
    edCtoC.Text := (lValue).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edFtoC.Text := ((lValue - 32) / 1.8).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edKtoC.Text := (lValue - 273.15).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edCtoF.Text := (lValue * 1.8 + 32).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edFtoF.Text := (lValue).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edKtoF.Text := (lValue * 1.8 - 459.67).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edCtoK.Text := (lValue + 273.15).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edFtoK.Text := ((lValue + 459.67) / 1.8).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edKtoK.Text := (lValue).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edMItoKM.Text := (lValue / 0.621371192).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
    edKMtoMI.Text := (lValue * 0.621371192).ToString(System.Globalization.NumberFormatInfo.InvariantInfo);
  except
    edCtoC.Text := 'Invalid number';
    edFtoC.Text := 'Invalid number';
    edKtoC.Text := 'Invalid number';
    edCtoF.Text := 'Invalid number';
    edFtoF.Text := 'Invalid number';
    edKtoF.Text := 'Invalid number';
    edCtoK.Text := 'Invalid number';
    edFtoK.Text := 'Invalid number';
    edKtoK.Text := 'Invalid number';
    edMItoKM.Text := 'Invalid number';;
    edKMtoMI.Text := 'Invalid number';
    exit;
  end;
end;

end.