namespace org.me.listviewapp;

{
  This makes a preference screen, automatically mapping shared preferences from the 
  default shared preferences file onto the widgets as defined in the related XML file.
  The single preference represented here, and used by the two ListViewActivities
  is 'use_custom_adapter_preference'
}

interface

uses
  java.util,
  android.app,
  android.content,
  android.os,
  android.preference,
  android.view,
  android.widget,
  android.util
  ;

type
  ListViewActivitySettingsActivity = public class(PreferenceActivity)
  protected
    method onCreate(savedInstanceState: Bundle); override;
  public
    const AdapterPreference = 'use_custom_adapter_preference';
  end;

implementation

method ListViewActivitySettingsActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  addPreferencesFromResource(R.xml.listviewactivitypreferences);
end;

end.