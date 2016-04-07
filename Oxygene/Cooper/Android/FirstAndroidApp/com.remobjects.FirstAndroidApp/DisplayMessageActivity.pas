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
  DisplayMessageActivity = public class(Activity)
  private
  protected
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method DisplayMessageActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  var intent: Intent := getIntent();
  var message: String := intent.getStringExtra(MainActivity.EXTRA_MESSAGE);

  //  Create the text view
  var textView: TextView := new TextView(self);
  textView.TextSize := 40;
  textView.Text := message;

  //  Set the text view as the activity layout
  ContentView := textView;
end;

end.
