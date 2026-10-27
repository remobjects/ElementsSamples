namespace org.me.torch;

//Sample app by Brian Long (http://blong.com)

{
  This example demonstrates a number of things:
  - how to invoke a confirmation dialog
  - how to make a 'toast' message
  - how to launch another activity
  - how to make a full screen activity (no status bar)
  - how to remove the activity title bar
  - how to use a wake lock to prevent the screen from sleeping
  - how to set up an options menu (one that shows when you press the Menu button)
  - how to set up a context menu (one that shows after a long press)
}

interface

uses
  java.util,
  android.os,
  android.app, 
  android.content,
  android.view,
  android.widget,
  android.util;
  
type
  MainActivity = public class(Activity)
  private
    const CONFIRM_TORCH_DIALOG = 1;
  protected
    method onCreateDialog(id: Integer): Dialog; override;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method TorchDialog_YesClickedEvent(dialog: DialogInterface; which: Integer);
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  // Set our view from the "main" layout resource
  ContentView := R.layout.main;
  // Get our button from the layout resource,
  // and attach an event to it
  var torchButton := findViewById(R.id.torchButton) as Button;
  //torchButton.OnClickListener := method begin ShowDialog(CONFIRM_TORCH_DIALOG); end;
  torchButton.OnClickListener := -> showDialog(CONFIRM_TORCH_DIALOG);
end;

method MainActivity.onCreateDialog(id: Integer): Dialog;
begin
  Result := inherited;
  if id = CONFIRM_TORCH_DIALOG then
  begin
    //Create dialog here and return it
    //Note this is called just once regardless of number of invocations, unless you call RemoveDialog()
    var builder := new AlertDialog.Builder(Self);
    builder.Message := R.string.torchDialog_Message;
    builder.setPositiveButton(Android.R.string.yes, @TorchDialog_YesClickedEvent);
    builder.setNegativeButton(Android.R.string.no, (dialog, which) -> dialog.cancel);
    Result := builder.&create;
  end;
end;

method MainActivity.TorchDialog_YesClickedEvent(dialog: DialogInterface; which: Integer);
begin
  //Brief popup message aka toast
  Toast.makeText(Self, R.string.torchButton_Toast, Toast.LENGTH_SHORT).show;
  //Now show the torch screen
  //var i := new Intent(self, java.lang.Class.ForName("org.me.torch.TorchActivity"));
  var i := new Intent(self, typeOf(TorchActivity));
  startActivity(i)
end;

end.