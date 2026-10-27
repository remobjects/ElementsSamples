namespace org.me.torch;

interface

uses
  java.util,
  android.os,
  android.app,
  android.view,
  android.widget,
  android.hardware;
  
type
  TorchActivity = public class(Activity)
  private
    const SWITCH_OFF_TORCH_ID = 1;
    var mPowerManager: PowerManager;
    var mWakeLock: PowerManager.WakeLock;
    method MenuItemSelected(item: MenuItem): Boolean;
  public
    method onCreate(bundle: Bundle); override;
    method onCreateOptionsMenu(menu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
    method onCreateContextMenu(menu: ContextMenu; v: View; menuInfo: ContextMenu.ContextMenuInfo); override;
    method onContextItemSelected(item: MenuItem): Boolean; override;
    method onResume; override;
    method onPause; override;
  end;

implementation

method TorchActivity.onCreate(bundle: Bundle);
begin
  inherited;
  var mainLayout := new LinearLayout(Self);
  mainLayout.LayoutParams := new LinearLayout.LayoutParams(
    ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.FILL_PARENT);
  //The torch is white
  mainLayout.BackgroundColor := $FFFFFFFF as Integer;
  //Hide the regular activity title
  requestWindowFeature(Window.FEATURE_NO_TITLE);
  //Hide the OS status bar
  Window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
  //ensure this activity has full brightness
  Window.Attributes.screenBrightness := WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_FULL;
  // Get an instance of the PowerManager
  mPowerManager := PowerManager(SystemService[POWER_SERVICE]);
  // Create a bright wake lock. Requires WAKE_LOCK permission - see Android manifest file
  mWakeLock := mPowerManager.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK, &Class.Name);
  //Show the view
  ContentView := mainLayout;
  registerForContextMenu(mainLayout);
end;

method TorchActivity.onResume;
begin
  inherited;
  // Acquire wake lock to keep screen on
  mWakeLock.acquire;
end;

method TorchActivity.onPause;
begin
  inherited;
  // Release wake lock to allow screen to turn off, as per normal
  mWakeLock.release;
end;

method TorchActivity.onCreateOptionsMenu(menu: Menu): Boolean;
begin
  var item := menu.add(0, SWITCH_OFF_TORCH_ID, 0, R.string.torchMenuItem_Text);
  //Options menu items support icons
  item.Icon := Android.R.drawable.ic_menu_close_clear_cancel;
  Result := True;
end;

method TorchActivity.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  exit MenuItemSelected(item)
end;

method TorchActivity.onCreateContextMenu(menu: ContextMenu; v: View; menuInfo: ContextMenu.ContextMenuInfo);
begin
  inherited;
  menu.add(0, SWITCH_OFF_TORCH_ID, 0, R.string.torchMenuItem_Text);
end;

method TorchActivity.onContextItemSelected(item: MenuItem): Boolean;
begin
  exit MenuItemSelected(item)
end;

method TorchActivity.MenuItemSelected(item: MenuItem): Boolean;
begin
  if item.ItemId = SWITCH_OFF_TORCH_ID then
  begin
    finish;
    exit True
  end;
  exit False;
end;

end.
