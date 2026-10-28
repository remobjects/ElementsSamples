namespace org.me.serviceapp;

// Sample app by Brian Long (http://blong.com).
// This activity-scoped service demonstrates two-way, package-local broadcasts.
// A main-loop timer has no worker thread to outlive onDestroy.

uses android.os, android.app, android.content;

type
  SampleService = public class(Service)
  private

    field fReceiver: ServiceReceiver;
    field fHandler: Handler;
    field fTick: Runnable;
    field fStartValue: Integer;
    field fIteration: Integer;
    field fRunning: Boolean;

  public

    const SAMPLE_SERVICE_ACTION = "org.me.serviceapp.SAMPLE_SERVICE_ACTION";
    const ID_INT_START_VALUE = "START_VALUE";
    const ID_INT_ITERATION = "ITERATION";
    const ID_INT_CALCULATED_VALUE = "CALCULATED_VALUE";
    const ID_INT_COMMAND = "COMMAND";
    const CMD_STOP_SERVICE = 1;

    method onCreate; override;
    begin
      inherited;
      fHandler := new Handler(Looper.MainLooper);
      fReceiver := new ServiceReceiver(self);
      var lFilter := new IntentFilter(ServiceInteractionActivity.SAMPLE_ACTIVITY_ACTION);
      if Build.VERSION.SDK_INT ≥ 33 then
        registerReceiver(fReceiver, lFilter, Context.RECEIVER_NOT_EXPORTED)
      else
        registerReceiver(fReceiver, lFilter);
      fTick := method begin
        if not fRunning then
          exit;
        inc(fIteration);
        var lIntent := new Intent(SAMPLE_SERVICE_ACTION);
        lIntent.setPackage(PackageName);
        lIntent.putExtra(ID_INT_ITERATION, fIteration);
        lIntent.putExtra(ID_INT_CALCULATED_VALUE, fIteration + fStartValue);
        sendBroadcast(lIntent);
        fHandler.postDelayed(fTick, 5000);
      end;
    end;

    method onStartCommand(aIntent: Intent; aFlags: Integer; aStartId: Integer): Integer; override;
    begin
      if not fRunning then begin
        fStartValue := if assigned(aIntent) then aIntent.getIntExtra(ID_INT_START_VALUE, 1) else 1;
        fIteration := 0;
        fRunning := true;
        fHandler.postDelayed(fTick, 5000);
      end;
      result := Service.START_NOT_STICKY;
    end;

    method onDestroy; override;
    begin
      fRunning := false;
      fHandler.removeCallbacksAndMessages(nil);
      unregisterReceiver(fReceiver);
      inherited;
    end;

    method onBind(aIntent: Intent): IBinder; override;
    begin
      result := nil;
    end;

  end;

  ServiceReceiver nested in SampleService = private class(BroadcastReceiver)
  private

    field fService: SampleService;

  public

    constructor(aService: SampleService);
    begin
      inherited constructor;
      fService := aService;
    end;

    method onReceive(aContext: Context; aIntent: Intent); override;
    begin
      if aIntent.getIntExtra(ID_INT_COMMAND, 0) = CMD_STOP_SERVICE then
        fService.stopSelf;
    end;

  end;

end.
