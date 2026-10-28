namespace org.me.tabbedapp;

// Sample app by Brian Long (http://blong.com), updated for a single Activity.
// Native view tabs keep their state across selection and restore the selected tab.

uses android.app, android.os, android.view, android.widget;

type
  MainActivity = public class(Activity)
  private

    field fTabs: RadioGroup;
    field fContent: TextView;
    const SelectedTabKey = "selectedTab";

    method selectTab(aIndex: Integer);
    begin
      case aIndex of
        1: fContent.Text := "This is tab one";
        2: fContent.Text := "This is tab two";
        3: fContent.Text := "This is tab three";
      end;
    end;

  public

    method onCreate(aSavedInstanceState: Bundle); override;
    begin
      inherited onCreate(aSavedInstanceState);
      ContentView := R.layout.main;
      WindowInsetsSupport.apply(self);
      fTabs := RadioGroup(findViewById(R.id.tabs));
      fContent := TextView(findViewById(R.id.tab_content));
      fTabs.OnCheckedChangeListener := method(aGroup: RadioGroup; aCheckedId: Integer) begin
        selectTab(aCheckedId);
      end;
      var lTitles := [String[R.string.tab_one_title], String[R.string.tab_two_title], String[R.string.tab_three_title]];
      for i := 0 to lTitles.length - 1 do begin
        var lTab := new RadioButton(self);
        lTab.Id := i + 1;
        lTab.Text := lTitles[i];
        fTabs.addView(lTab, new RadioGroup.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1.0));
      end;
      var lSelected := if assigned(aSavedInstanceState) then aSavedInstanceState.getInt(SelectedTabKey, 1) else 1;
      fTabs.check(lSelected);
    end;

    method onSaveInstanceState(aState: Bundle); override;
    begin
      aState.putInt(SelectedTabKey, fTabs.CheckedRadioButtonId);
      inherited onSaveInstanceState(aState);
    end;

  end;

end.
