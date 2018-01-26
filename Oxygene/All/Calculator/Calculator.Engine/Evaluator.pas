namespace Calculator.Engine;

interface

uses
  RemObjects.Elements.RTL;

type
  EvaluatorTokenType = private enum (
    EOF,
    Number,
    Op_Add,
    Op_Sub,
    Op_Mul,
    Op_Div,
    Error
  );

  EvaluatorError = private class(Exception)
  end;

  EvaluatorToken = private class
  public
    var Token: EvaluatorTokenType;
    var Value: String;
    var Offset: Integer;
    constructor(_token: EvaluatorTokenType; _value: String; _offset: Integer);
  end;

  Evaluator = public class
  private
    class var EOF: EvaluatorToken := new EvaluatorToken(EvaluatorTokenType.EOF, '', 0);
    var Tokens: List<EvaluatorToken>;
    var &Index: Integer := 0;
    property Current: EvaluatorToken read getCurrent;
    method getCurrent: EvaluatorToken;
  public
    //  Evaluates a string expression like (1 + 2 * 4.5) and return the evaluated value
    method Evaluate(input: String): Double;
  private
    //  Parses + and - expressions, this is split from * and / so that
    //  + and - have a lower prescendence than * and /
    method ParseAdditionExpression: Double;
    //  Parse * and /
    method ParseMultiplicationExpression: Double;
    method ParseValueExpression: Double;
    //  Splits the string into parts; skipping whitespace
    class method Tokenize(input: String): List<EvaluatorToken>;
  end;

implementation

constructor EvaluatorToken(_token: EvaluatorTokenType; _value: String; _offset: Integer);
begin
  self.Token := _token;
  self.Value := _value;
  self.Offset := _offset;
end;

method Evaluator.getCurrent: EvaluatorToken;
begin
  if (Tokens <> nil) and (&Index < Tokens.Count) then
    exit Tokens[&Index];
  exit EOF;
end;

method Evaluator.Evaluate(input: String): Double;
begin
  Tokens := Tokenize(input);
  &Index := 0;
  exit ParseAdditionExpression();
end;

method Evaluator.ParseAdditionExpression: Double;
begin
  var l := ParseMultiplicationExpression();
  while (Current.Token = EvaluatorTokenType.Op_Sub) or (Current.Token = EvaluatorTokenType.Op_Add) do begin
    var sub := Current.Token = EvaluatorTokenType.Op_Sub;
    inc(&Index);
    var r := ParseMultiplicationExpression();
    if sub then
      l := l - r
    else
      l := l + r;
  end;
  exit l;
end;

method Evaluator.ParseMultiplicationExpression: Double;
begin
  var l := ParseValueExpression();
  while (Current.Token = EvaluatorTokenType.Op_Mul) or (Current.Token = EvaluatorTokenType.Op_Div) do begin
    var mul := Current.Token = EvaluatorTokenType.Op_Mul;
    inc(&Index);
    var r := ParseValueExpression();
    if mul then
      l := l * r
    else
      l := l / r;
  end;
  exit l;
end;

method Evaluator.ParseValueExpression: Double;
begin
  case Current.Token of
    EvaluatorTokenType.Op_Add: begin
      //  Process +15 as unary
      inc(&Index);
      exit ParseValueExpression();
    end;
    EvaluatorTokenType.Op_Sub: begin
      //  Process -15 as unary
      inc(&Index);
      exit -ParseValueExpression();
    end;
    EvaluatorTokenType.Number: begin
      var res := Current.Value;
      inc(&Index);
      exit Convert.ToDoubleInvariant(res);
    end;
    EvaluatorTokenType.EOF: begin
      raise new EvaluatorError('Unexected end of expression');
    end;
    else begin
      raise new EvaluatorError('Unknown value at offset ' + Current.Offset);
    end;
  end;
end;

class method Evaluator.Tokenize(input: String): List<EvaluatorToken>;
begin
  var res := new List<EvaluatorToken>();
  //  for parsing convenience so look ahead won't throw exceptions.
  input := input + #0#0;
  var i := 0;
  while i < input.Length do begin
    var c: Integer := i;
    case input[i] of
       #0:
        i := input.Length;
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.': begin
        c := i + 1;
        var gotDot := input[i] = '.';
        while true do begin
          var ch := input[c];
          if ((ch = '0') or (ch = '1') or (ch = '2') or (ch = '3') or (ch = '4') or (ch = '5') or (ch = '6') or (ch = '7') or (ch = '8') or (ch = '9') or (not gotDot and (ch = '.'))) then begin
            inc(c);
            if ch = '.' then
              gotDot := true;
          end
          else
            break;
        end;
        res.&Add(new EvaluatorToken(EvaluatorTokenType.Number, input.Substring(i, c - i), i));
        i := c;
      end;
      '+': begin
        res.&Add(new EvaluatorToken(EvaluatorTokenType.Op_Add, '+', i));
        inc(i);
      end;
      '-': begin
        res.&Add(new EvaluatorToken(EvaluatorTokenType.Op_Sub, '-', i));
        inc(i);
      end;
      '*': begin
        res.&Add(new EvaluatorToken(EvaluatorTokenType.Op_Mul, '*', i));
        inc(i);
      end;
      '/': begin
        res.&Add(new EvaluatorToken(EvaluatorTokenType.Op_Div, '/', i));
        inc(i);
      end;
      ' ', #9, #13, #10: begin
        res.&Add(new EvaluatorToken(EvaluatorTokenType.Error, input[i].toString(), i));
        inc(i);
      end;
    end;
  end;
  exit res;
end;

end.