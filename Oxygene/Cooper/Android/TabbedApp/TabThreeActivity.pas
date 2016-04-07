namespace org.me.tabbedapp;

interface

uses
  java.util,
  android.os,
  android.app,
  android.util,
  android.view,
  android.widget;
  
type
  TabThreeActivity = public class(Activity)
  private
  protected
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method TabThreeActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  //This activity is just representative of a real activity. Its UI is so trivial 
  //(one textview) that it is created dynamically rather than via a layout file
  var textView := new TextView(self);
  textView.Text := "This is tab three";
  ContentView := textView
end;

end.
