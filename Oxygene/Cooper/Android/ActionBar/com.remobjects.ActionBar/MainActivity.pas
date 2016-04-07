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
  MainActivity = public class(Activity)
  protected 
     method openSearch();
    method openSettings();
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onCreateOptionsMenu(menu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  // Set our view from the "main" layout resource
  ContentView := R.layout.main;
end;

method MainActivity.onCreateOptionsMenu(menu : Menu) : Boolean;
begin
  var inflater := getMenuInflater();
  inflater.inflate(R.menu.main_activity_actions, menu);
  result := inherited onCreateOptionsMenu(menu);
end;

method MainActivity.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  case item.getItemId() of
    R.id.action_search:
    begin
      self.openSearch();
      result := true;
    end;
    R.id.action_settings: 
    begin
      self.openSettings();
      result := true;
    end
    else
      result :=  inherited onOptionsItemSelected(item);
   end;
end;

method MainActivity.openSearch();
begin
  var intent  := new Intent(self, typeOf(SearchActivity));
  startActivity(intent);
end;

method MainActivity.openSettings();
begin 
  var intent  := new Intent(self, typeOf(SettingsActivity));
  startActivity(intent);
end;

end.
