namespace org.me.openglapplication;

interface

uses
  android.app,
  android.os,
  android.view,
  android.widget;

type
  AboutActivity = public class(Activity)
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onTouchEvent(AnEvent: MotionEvent): Boolean; override;
  end;

implementation

method AboutActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  setContentView(R.layout.about);
  var Text := TextView(findViewById(R.id.aboutText));
  //Make the text respond to touch by calling the same code
  //that touching exposed parts of the activity triggers
  Text.OnTouchListener := (v, e) -> onTouchEvent(e)
end;

//If the user touches part of the activity, close this about box
method AboutActivity.onTouchEvent(AnEvent: MotionEvent): Boolean;
begin
  if AnEvent.Action = MotionEvent.ACTION_DOWN then begin
	  finish;
    exit true;
  end;
	exit false;
end;

end.
