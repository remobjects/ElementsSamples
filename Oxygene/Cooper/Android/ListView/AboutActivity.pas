namespace org.me.listviewapp;

interface

uses
  android.app,
  android.os;

type
  //This activity apppears as a dialog over the previous activity,
  //thanks to a theme specified against it in the Android manifest file
  AboutActivity = public class(Activity)
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method AboutActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  setContentView(R.layout.about);
end;

end.
