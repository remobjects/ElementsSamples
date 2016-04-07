namespace Indigo;

interface

uses
  System.Drawing,
  System.Collections,
  System.Collections.Generic,
  System.Linq,
  System.Windows.Forms,
  System.ComponentModel,
  System.ServiceModel, System.ServiceModel.Description;

type
  /// <summary>
  /// Summary description for MainForm.
  /// </summary>
  MainForm = partial class(System.Windows.Forms.Form)
  private
    method bGetServerTime_Click(sender: System.Object; e: System.EventArgs);
    method bArithm_Click(sender: System.Object; e: System.EventArgs);
    method InitChannel();
    var 
      factory : ChannelFactory<IndigoServiceChannel>;
      proxy : IndigoServiceChannel;
      endpointChanged : Boolean;
  method comboBoxEndpoints_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(disposing: Boolean); override;
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

  comboBoxEndpoints.SelectedIndex := 0;
end;

method MainForm.Dispose(disposing: Boolean);
begin
  if disposing then begin
    if assigned(components) then
      components.Dispose();

    //
    // TODO: Add custom disposition code here
    //
  end;
  inherited Dispose(disposing);
end;
{$ENDREGION}

method MainForm.bGetServerTime_Click(sender: System.Object; e: System.EventArgs);
begin
  InitChannel;  
  MessageBox.Show("Server time is: " + proxy.GetServerTime().ToString() + Environment.NewLine + "Invoked endpoint: " + factory.Endpoint.Name);
end;

method MainForm.bArithm_Click(sender: System.Object; e: System.EventArgs);
    var responce : CalculationMessage := new CalculationMessage();
    operation : Char; Res : Decimal;
begin
    if (radioButtonPlus.Checked) then operation := '+'
    else
    if (radioButtonMinus.Checked) then operation := '-'
    else
    if (radioButtonMult.Checked) then operation := '*'
    else
    if (radioButtonDiv.Checked) then operation := '/';

    var numbers : Operands := new Operands;
    numbers.operand1 := nudA.Value; numbers.operand2 := nudB.Value;

    var request : CalculationMessage := new CalculationMessage(operation,  numbers, Res);
    
    InitChannel;  
    responce := proxy.Calculate(request);

    MessageBox.Show("Result: " + responce.Res.ToString() + Environment.NewLine + "Invoked endpoint: " + factory.Endpoint.Name);  
end;

method MainForm.InitChannel;
begin
  if (endpointChanged) then
  begin
    factory := new ChannelFactory<IndigoServiceChannel>(comboBoxEndpoints.SelectedItem.ToString);
    proxy := factory.CreateChannel();
    endpointChanged := false;
  end;
end;

method MainForm.comboBoxEndpoints_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
begin
  endpointChanged := true;  
end;

end.