namespace com.remobjects.actionbar;

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
  SettingsActivity = public class(Activity)
  private
  protected
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method SettingsActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
    //  Create the text view
  var textView: TextView := new TextView(self);
  textView.TextSize := 40;
  textView.Text := "Settings Activity";

  //  Set the text view as the activity layout
  ContentView := textView;

  //Set the Up Button Action in the ActionBar
  getActionBar().setDisplayHomeAsUpEnabled(true);
end;

end.
