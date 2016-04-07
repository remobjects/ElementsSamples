namespace Indigo;

interface

uses
  System.Collections.Generic,
  System.Linq,
  System.Text, System.ServiceModel, System.Runtime.Serialization;

type
  [ServiceContract]
  IndigoService = public class
  public
    [OperationContract]
    method GetServerTime() : DateTime;
    [OperationContract]
    method Calculate(request:CalculationMessage) : CalculationMessage;
  end;

type
  [MessageContract]
  CalculationMessage = public class

  public
    constructor (); empty;
    constructor (O : Char; Nums : Operands; R : Decimal);
    constructor (message : CalculationMessage);
    var 
      [MessageHeader]
      Operation : String;

      [MessageBodyMember]
      Numbers : Operands;
      [MessageBodyMember]
      Res : Decimal;
  end;

type 
  [DataContract]
  Operands = public class

  public
    constructor (); empty;
    constructor (firstOperand : Decimal; secondOperand : Decimal);

    var 
      [DataMember]
      operand1 : Decimal;
      [DataMember]
      operand2 : Decimal;
  end;

implementation

method IndigoService.GetServerTime: DateTime;
begin
    Console.WriteLine("GetServerTime method called.");
    result := DateTime.Now;
end;

method IndigoService.Calculate(request: CalculationMessage): CalculationMessage;
begin
  
    Console.WriteLine("Calculate method for " + request.Numbers.operand1 + request.Operation + request.Numbers.operand2 + " called.");
    var response: CalculationMessage := new CalculationMessage(request);
    case request.Operation of 
        '+':
        begin
            response.Res := request.Numbers.operand1 + request.Numbers.operand2;
            result := response;
            exit
        end;
        '-':
        begin
            response.Res := request.Numbers.operand1 - request.Numbers.operand2;
            result := response;
            exit
        end;
        '*':
        begin
            response.Res := request.Numbers.operand1 * request.Numbers.operand2;
            result := response;
            exit
        end;
        '/':
        begin
            response.Res := request.Numbers.operand1 div request.Numbers.operand2;
            result := response;
            exit
        end;
    end;
    response.Res := 0;
    result := response;
end;

constructor CalculationMessage(O : Char; Nums : Operands; R : Decimal);
begin
   self.Operation := O;
   self.Numbers := Nums;
   self.Res := R
end;

constructor CalculationMessage(message : CalculationMessage);
begin
   self.Operation := message.Operation;
   self.Numbers := message.Numbers;
   self.Res := message.Res
end;

constructor Operands(firstOperand, secondOperand : Decimal);
begin
  self.operand1 := firstOperand;
  self.operand2 := secondOperand;
end;

end.