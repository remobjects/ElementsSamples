namespace com.remobjects.firstandroidapp;

interface

uses
  java.util,
  android.app,
  android.content,
  android.os,
  android.util,
  android.view,
  android.widget;

type
  MainActivity = public class(Activity)
  public
    method onCreate(savedInstanceState: Bundle); override;
    method sendMessage(view: View);
    const EXTRA_MESSAGE = "com.example.myfirstapp.MESSAGE";
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  // Set our view from the "main" layout resource
  ContentView := R.layout.main;
end;

method MainActivity.sendMessage(view: View);
begin
  var intent: Intent := new Intent(self, typeOf(DisplayMessageActivity));
  var editTxt := EditText(findViewById(R.id.edit_message));
  var message: String := editTxt.getText().toString();
  intent.putExtra(EXTRA_MESSAGE, message);
  startActivity(intent);
end;



end.
