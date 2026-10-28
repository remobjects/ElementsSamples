namespace org.me.serviceapp;

// Sample app by Brian Long (http://blong.com).
// Keep this demonstration service alive only while its activity is visible.
// Long-running background work should use a suitable foreground service or job.

uses android.os, android.app, android.content, android.view, android.widget;

type
  ServiceInteractionActivity = public class(Activity)
  private

    field fReceiver: ActivityReceiver;

  public

    const SAMPLE_ACTIVITY_ACTION = "org.me.serviceapp.SAMPLE_ACTIVITY_ACTION";

    method onCreate(aSavedInstanceState: Bundle); override;
    begin
      inherited onCreate(aSavedInstanceState);
      ContentView := R.layout.main;
      WindowInsetsSupport.apply(self);
      var lStopButton := Button(findViewById(R.id.stopServiceButton));
      lStopButton.OnClickListener := method(aView: View) begin
        var lIntent := new Intent(SAMPLE_ACTIVITY_ACTION);
        lIntent.setPackage(PackageName);
        lIntent.putExtra(SampleService.ID_INT_COMMAND, SampleService.CMD_STOP_SERVICE);
        sendBroadcast(lIntent);
      end;
      fReceiver := new ActivityReceiver;
    end;

    method onStart; override;
    begin
      inherited;
      var lFilter := new IntentFilter(SampleService.SAMPLE_SERVICE_ACTION);
      if Build.VERSION.SDK_INT ≥ 33 then
        registerReceiver(fReceiver, lFilter, Context.RECEIVER_NOT_EXPORTED)
      else
        registerReceiver(fReceiver, lFilter);
      var lIntent := new Intent(self, typeOf(SampleService));
      lIntent.putExtra(SampleService.ID_INT_START_VALUE, 10);
      startService(lIntent);
    end;

    method onStop; override;
    begin
      stopService(new Intent(self, typeOf(SampleService)));
      unregisterReceiver(fReceiver);
      inherited;
    end;

  end;

  ActivityReceiver nested in ServiceInteractionActivity = private class(BroadcastReceiver)
  public

    method onReceive(aContext: Context; aIntent: Intent); override;
    begin
      var lIteration := aIntent.getIntExtra(SampleService.ID_INT_ITERATION, 0);
      var lValue := aIntent.getIntExtra(SampleService.ID_INT_CALCULATED_VALUE, 0);
      Toast.makeText(aContext, "Received call " + String.valueOf(lIteration) + " from service\n" +
        "with calculated value " + String.valueOf(lValue), Toast.LENGTH_SHORT).show;
    end;

  end;

end.
