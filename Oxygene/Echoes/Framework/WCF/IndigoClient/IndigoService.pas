namespace Indigo;
interface
uses
  System.Collections.Generic,
  System.Linq,
  System.Text, System.ServiceModel;

type
  [System.Diagnostics.DebuggerStepThroughAttribute()]
  [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "3.0.0.0")]
  [System.Runtime.Serialization.DataContractAttribute(Name :="Operands")]
Operands = public partial class (Object, System.Runtime.Serialization.IExtensibleDataObject)

private
  var
    extensionDataField : System.Runtime.Serialization.ExtensionDataObject;
    firstOperand : Decimal;
    secondOperand : Decimal;
public
    property extensionData : System.Runtime.Serialization.ExtensionDataObject read extensionDataField write extensionDataField;

    [System.Runtime.Serialization.DataMemberAttribute(Order := 0)]
    property operand1 : Decimal read firstOperand write firstOperand;

    [System.Runtime.Serialization.DataMemberAttribute(Order := 1)]
    property operand2 : Decimal read secondOperand write secondOperand;

end;

type
  [System.CodeDom.Compiler.GeneratedCode("System.ServiceModel", "3.0.0.0")]
  [System.ServiceModel.ServiceContractAttribute(ConfigurationName:="IndigoService")]
  IndigoService = public interface

    [System.ServiceModel.OperationContractAttribute(Action:="http://tempuri.org/IndigoService/GetServerTime", ReplyAction:="http://tempuri.org/IndigoService/GetServerTimeResponse")]
    method GetServerTime() : DateTime;

    [System.ServiceModel.OperationContractAttribute(Action:="http://tempuri.org/IndigoService/Calculate", ReplyAction:="http://tempuri.org/IndigoService/CalculateResponse")]
    method Calculate(request : CalculationMessage) : CalculationMessage;
  end;

type
  [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
  IndigoServiceChannel = public interface (IndigoService, System.ServiceModel.IClientChannel)

  end;

type
  [System.Diagnostics.DebuggerStepThroughAttribute()]
  [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
  IndigoServiceClient = public partial class (System.ServiceModel.ClientBase<IndigoService>, IndigoService)

  public
    method GetServerTime() : DateTime;
    method Calculate(request : CalculationMessage) : CalculationMessage;
  end;

type
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
[System.ServiceModel.MessageContractAttribute(WrapperName := "CalculationMessage", WrapperNamespace := "http://tempuri.org/", IsWrapped := true)]
CalculationMessage = public partial class

private
public
  var
    [System.ServiceModel.MessageHeaderAttribute]
    Operation : String;

    [System.ServiceModel.MessageBodyMemberAttribute(Order := 1)]
    Numbers : Operands;

    [System.ServiceModel.MessageBodyMemberAttribute(Order := 2)]
    Res : Decimal;

    constructor (); empty;

    constructor (O : String; Nums : Operands; R : Decimal);

end;



implementation
method IndigoServiceClient.GetServerTime: DateTime;
begin
  result := Channel.GetServerTime();
end;

method IndigoServiceClient.Calculate(request : CalculationMessage) : CalculationMessage;
begin
  result := Channel.Calculate(request);
end;

constructor CalculationMessage(O : String; Nums : Operands; R : Decimal);
begin
   self.Operation := O;
   self.Numbers := Nums;
   self.Res := R
end;

end.