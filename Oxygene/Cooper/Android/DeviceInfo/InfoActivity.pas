namespace org.me.deviceinfo;

//Sample app by Brian Long (http://blong.com)

{
  This example demonstrates querying an Android device for various metrics and data
}

{$define USING_API_9}
{$define USING_API_10}
{$define USING_API_11}
{$define USING_API_12}

interface

uses
  java.util,
  android.app,
  android.content,
  android.content.res,
  android.os,
  android.view,
  android.util,
  android.widget;

//Queries various data and metrics from the device

//This activity uses a number of rows with similar layout for the information
//In this case they are created dynamically and added to an empty parent,
//keeping a list of references to the TextViews inside.
//The layout is an OS-defined one.

type
  InfoActivity = public class(Activity)
  private
    infoItems: ArrayList<TextView>;
    const
      OS_VERSION = 0;
      DEVICE_MANUFACTURER = 1;
      DEVICE_MODEL = 2;
      DEVICE_BRAND = 3;
      DEVICE_PRODUCT = 4;
      DEVICE_HARDWARE = 5;
      DEVICE_DISPLAY = 6;
      DEVICE_CPU_ABI = 7;
      DEVICE_BOOTLOADER = 8;
      SCREEN_RESOLUTION = 9;
      SCREEN_DENSITY = 10;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onResume; override;
  end;

implementation

method InfoActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  ContentView := R.layout.info;
  var listView := LinearLayout(findViewById(R.id.list));
  //Set up an array of string ids
  var infoLabels: array of Integer := [R.string.os_version, R.string.device_manufacturer,
    R.string.device_model, R.string.device_brand, R.string.device_product,
    R.string.device_hardware, R.string.device_build_id, R.string.device_cpu_abi,
    R.string.device_bootloader, R.string.screen_resolution, R.string.screen_density];
  //Empty list of TextViews
  infoItems := new ArrayList<TextView>();
  //Now loop through the string id array, creating a pre-defined 2 item list
  //view item for each one, setting the first item (TextView) to the string
  //and adding the second item (TextView) to the listview
  for I: Integer := 0 to infoLabels.length - 1 do 
  begin
    var listItem := LayoutInflater.inflate(Android.R.layout.simple_list_item_2, nil);
    var infoLabel := TextView(listItem.findViewById(Android.R.id.text1));
    infoLabel.Text := String[infoLabels[I]];
    infoItems.add(TextView(listItem.findViewById(Android.R.id.text2)));
    listView.addView(listItem)
  end
end;

//When activity displays, populate all the list items with data about the device
method InfoActivity.onResume;
begin
  inherited;
  //This is a use of a case expression (as opposed to a case statement)
  var releaseName := case Build.VERSION.SDK_INT of 
    Build.VERSION_CODES.BASE: 'Android 1 aka Base, October 2008';
    Build.VERSION_CODES.BASE_1_1: 'Android 1.1 aka Base 1 1, February 2009';
    Build.VERSION_CODES.CUPCAKE: 'Android 1.5 aka Cupcake, May 2009';
    Build.VERSION_CODES.DONUT: 'Android 1.6 aka Donut, September 2009';
    Build.VERSION_CODES.ECLAIR: 'Android 2.0 aka Eclair, November 2009';
    Build.VERSION_CODES.ECLAIR_0_1: 'Android 2.0.1 aka Eclair 0 1, December 2009';
    Build.VERSION_CODES.ECLAIR_MR1: 'Android 2.1 aka Eclair MR 1, January 2010';
    Build.VERSION_CODES.FROYO: 'Android 2.2 aka FroYo, June 2010';
  {$ifdef USING_API_9}
    Build.VERSION_CODES.GINGERBREAD: 'Android 2.3 aka GingerBread, November 2010';
  {$endif}
  {$ifdef USING_API_10}
    Build.VERSION_CODES.GINGERBREAD_MR1: 'Android 2.3.3 aka GingerBread MR 1, February 2011';
  {$endif}
  {$ifdef USING_API_11}
    Build.VERSION_CODES.HONEYCOMB: 'Android 3.0 aka Honeycomb, February 2011';
  {$endif}
  {$ifdef USING_API_12}
    Build.VERSION_CODES.HONEYCOMB_MR1: 'Android 3.1 aka Honeycomb MR1, May 2011';
  {$endif}
  {$ifdef USING_API_13}
    Build.VERSION_CODES.HONEYCOMB_MR2: 'Android 3.2 aka Honeycomb MR2, June 2011';
  {$endif}
    Build.VERSION_CODES.CUR_DEVELOPMENT: 'Current development build';
    else 'Unknown version';
  end;
  var codeName := iif(Build.VERSION.CODENAME = 'REL', 'release build', 'codename ' + Build.VERSION.CODENAME);
  infoItems[OS_VERSION].Text := WideString.format('Version %s build %s - %s%n%s', Build.VERSION.RELEASE, Build.VERSION.INCREMENTAL, codeName, releaseName);
  infoItems[DEVICE_MANUFACTURER].Text := WideString.format('%s', Build.MANUFACTURER);
  infoItems[DEVICE_MODEL].Text :=        WideString.format('%s', Build.MODEL);
  infoItems[DEVICE_BRAND].Text :=        WideString.format('%s', Build.BRAND);
  infoItems[DEVICE_PRODUCT].Text :=      WideString.format('%s', Build.PRODUCT);
  infoItems[DEVICE_HARDWARE].Text :=     WideString.format('%s', Build.HARDWARE);
  infoItems[DEVICE_DISPLAY].Text :=      WideString.format('%s', Build.DISPLAY);
  infoItems[DEVICE_CPU_ABI].Text :=      WideString.format('%s', Build.CPU_ABI);
  infoItems[DEVICE_BOOTLOADER].Text :=   WideString.format('%s', Build.BOOTLOADER);
  var config := Resources.Configuration;
  var screenSize := case config.screenLayout and Configuration.SCREENLAYOUT_SIZE_MASK of 
    Configuration.SCREENLAYOUT_SIZE_SMALL:  'small';
    Configuration.SCREENLAYOUT_SIZE_NORMAL: 'normal';
    Configuration.SCREENLAYOUT_SIZE_LARGE:  'large';
  {$ifdef USING_API_9}
    Configuration.SCREENLAYOUT_SIZE_XLARGE: 'extra large';
  {$endif}
    else 'undefined'
  end + ' screen size';
  var sizeName := '';
  var dm := Resources.DisplayMetrics;
  if dm.densityDpi = DisplayMetrics.DENSITY_LOW then begin
    if (dm.widthPixels = 240) and (dm.heightPixels = 320) then sizeName := 'QVGA';
    if (dm.widthPixels = 240) and (dm.heightPixels = 400) then sizeName := 'WQVGA400';
    if (dm.widthPixels = 240) and (dm.heightPixels = 432) then sizeName := 'WQVGA432'
  end
  else if dm.densityDpi = DisplayMetrics.DENSITY_MEDIUM then begin
    if (dm.widthPixels = 320) and (dm.heightPixels = 480) then sizeName := 'HVGA';
    if (dm.widthPixels = 480) and (dm.heightPixels = 800) then sizeName := 'WVGA800';
    if (dm.widthPixels = 480) and (dm.heightPixels = 854) then sizeName := 'WVGA854'
  end
  else if dm.densityDpi = DisplayMetrics.DENSITY_HIGH then begin
    if (dm.widthPixels = 480) and (dm.heightPixels = 800) then sizeName := 'WVGA800';
    if (dm.widthPixels = 480) and (dm.heightPixels = 854) then sizeName := 'WVGA854'
  end
  {$ifdef USING_API_9}
  else if dm.densityDpi = DisplayMetrics.DENSITY_XHIGH then begin
    if (dm.widthPixels = 1280) and (dm.heightPixels = 800) then sizeName := 'WXGA';
  end
  {$endif}
  ;
  var screenOrientation := case config.orientation of 
    Configuration.ORIENTATION_LANDSCAPE: 'Landscape';
    Configuration.ORIENTATION_PORTRAIT: 'Portrait';
    Configuration.ORIENTATION_SQUARE: 'Qquare';
  end + ' orientation';
  if sizeName <> '' then  screenSize := sizeName + ' - ' + screenSize;
  infoItems[SCREEN_RESOLUTION].Text := WideString.format('%s%n%s%n%d x %d px%n%.0f x %.0f ppi',
    screenSize, screenOrientation, dm.widthPixels, dm.heightPixels, dm.xdpi, dm.ydpi);
  var densityStr := case dm.densityDpi of 
    DisplayMetrics.DENSITY_LOW:    'low density - ldpi';
    DisplayMetrics.DENSITY_MEDIUM: 'medium density - mdpi';
    DisplayMetrics.DENSITY_HIGH:   'high-density - hdpi';
  {$ifdef USING_API_9}
    DisplayMetrics.DENSITY_XHIGH:  'extra-high-density aka xhdpi';
  {$endif}
  {$ifdef USING_API_13}
    DisplayMetrics.DENSITY_TV:  densityStr := '720p TV';
  {$endif}
    else 'unknown density'
  end;
  infoItems[SCREEN_DENSITY].Text := WideString.format(
    'Density - %d dpi - %s%nLogical density - %.2f (dip scaling factor)%nFont scaling factor - %.2f',
    dm.densityDpi, densityStr, dm.density, dm.scaledDensity)
end;

end.