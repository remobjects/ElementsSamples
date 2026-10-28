namespace org.me.serviceapp;

uses android.app, android.os, android.view;

type
  WindowInsetsSupport = public static class
  public

    class method apply(aActivity: Activity);
    begin
      // Android 15 enforces edge-to-edge for these target-35 samples.
      // Earlier releases retain their normal decor fitting.
      if Build.VERSION.SDK_INT < 35 then
        exit;

      var lContent := aActivity.findViewById(android.R.id.content);
      var lLeft := lContent.PaddingLeft;
      var lTop := lContent.PaddingTop;
      var lRight := lContent.PaddingRight;
      var lBottom := lContent.PaddingBottom;
      lContent.OnApplyWindowInsetsListener := method(aView: View; aInsets: WindowInsets): WindowInsets begin
        var lInsets := aInsets.getInsets(WindowInsets.Type.systemBars or WindowInsets.Type.displayCutout or WindowInsets.Type.ime);
        aView.setPadding(lLeft + lInsets.left, lTop + lInsets.top,
          lRight + lInsets.right, lBottom + lInsets.bottom);
        result := WindowInsets.CONSUMED;
      end;
      lContent.requestApplyInsets;
    end;

  end;

end.
