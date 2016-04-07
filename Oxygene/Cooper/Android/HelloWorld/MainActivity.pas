namespace org.me.helloworld;

//Sample app by Brian Long (http://blong.com)

{
  This example is a simple Android application with a button that displays a dialog
}

interface

uses
  java.util,
  java.text,
  android.os,
  android.app,
  android.util,
  android.view,
  android.content,
  android.widget;
  
type
  MainActivity = public class(Activity)
  private
    //Identify the dialog
    const HelloDialog = 1;
    var helloButton: Button;   
  protected
    //Called the first time the dialog is displayed
    method onCreateDialog(Id: Integer): Dialog; override;
    //Called every time the dialog is displayed
    method onPrepareDialog(Id: Integer; Dlg: Dialog); override;
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  // Set our view from the "main" layout resource
  ContentView := R.layout.main;

  // Get our button from the layout resource,
  // and attach an event to it
  helloButton := Button(findViewById(R.id.helloButton));
  helloButton.OnClickListener :=  -> showDialog(HelloDialog);
end;

//This is called the first time the dialog is displayed
method MainActivity.onCreateDialog(Id: Integer): Dialog;
begin
  Result := inherited;
  if Id = HelloDialog then
  begin
    var builder := new AlertDialog.Builder(Self);
    //Put a default message on the dialog (though this will be overwritten in onPrepareDialog)
    builder.Message := R.string.hello_dialog_message;
    //Don't allow Back to get rid of the dialog
    builder.Cancelable := False;
    //Set up the positive response button, which happens to be the only button
    builder.setPositiveButton(R.string.hello_dialog_button_text, (s, a) -> (s as Dialog).dismiss);
    //Make the dialog
    Result := builder.&create;
    //Do something when the dialog is dismissed - update the activity's button
    Result.OnDismissListener := (d) -> begin helloButton.Text := String[R.string.hello_button_text_2] end;
  end;
end;

//This is called every time the dialog is displayed
method MainActivity.onPrepareDialog(Id: Integer; Dlg: Dialog);
begin
  if Id = HelloDialog then
  begin
    //Update the dialog's message
    var msg := Dlg.findViewById(Android.R.id.message) as TextView;
    if msg <> nil then
      msg.Text := String[R.string.hello_dialog_message_2] + DateFormat.DateTimeInstance.format(new Date);
  end
end;

end.