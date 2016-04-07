namespace org.remobjects.calculator;

interface

uses
  java.util,
  android.app,
  android.content,
  android.os,
  android.util,
  android.view,
  android.widget,
  Calculator.Engine;

type
  MainActivity = public class(Activity)
  private
    var TbValue: TextView;
    method btnBackspace(v: View);
    method btnExecute(v: View);
    method btnExit(v: View);
    method btnChar(v: View);
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method MainActivity.btnBackspace(v: View);
begin
  var s := TbValue.Text.toString();
  if s.length() > 0 then begin
    s := s.substring(0, s.length() - 1);
    TbValue.Text := s;
  end;
end;

method MainActivity.btnExecute(v: View);
begin
  try
    var eval := new Evaluator();
    var res := eval.Evaluate(TbValue.Text.toString());
    TbValue.Text := res.toString();
  except
    on e: Exception do
    begin
      var dlg := new AlertDialog.Builder(self);
      dlg.Message := 'Error evaluating: ' + e.Message;
      dlg.setPositiveButton('OK', nil);
      dlg.Cancelable := true;
      dlg.&create().show();
    end;
  end;
end;

method MainActivity.btnExit(v: View);
begin
  finish();
end;

method MainActivity.btnChar(v: View);
begin
  TbValue.Text := TbValue.Text.toString() + (Button(v)).Text.toString();
end;

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited onCreate(savedInstanceState);
  ContentView := R.layout.main;
  TbValue := TextView(findViewById(R.id.tbValue));
  (Button(findViewById(R.id.btnBackspace))).OnClickListener := @btnBackspace;
  (Button(findViewById(R.id.btnExit))).OnClickListener := @btnExit;
  (Button(findViewById(R.id.btnEval))).OnClickListener := @btnExecute;
  (Button(findViewById(R.id.btn0))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn1))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn2))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn3))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn4))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn5))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn6))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn7))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn8))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btn9))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btnAdd))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btnSub))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btnDiv))).OnClickListener := @btnChar;
  (Button(findViewById(R.id.btnMul))).OnClickListener := @btnChar;
end;

end.
