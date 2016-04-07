namespace org.me.serviceapp;

//Sample app by Brian Long (http://blong.com)

{
  This example shows an activity interacting with a service (both ways)
  via intents and broadcast receivers.

  This file defines the service and its broadcast receiver.
  The service uses a timer to send regular messages to the activity with information stored within.

  The service's broadcast receiver looks out for a message telling the service to stop.
}

interface

uses
  java.util,
  android.os,
  android.app,
  android.content,
  android.util,
  android.view,
  android.widget;
  
type
  SampleService = public class(Service)
  private
    const TAG = 'SvcAppService';
    var receiver: ServiceReceiver;
    var startValue: Integer;
    var running: Boolean := false;
  public
    const SAMPLE_SERVICE_ACTION = 'SAMPLE_SERVICE_ACTION';
    const ID_INT_START_VALUE = 'START_VALUE';
    const ID_INT_ITERATION = 'ITERATION';
    const ID_INT_CALCULATED_VALUE = 'CALCULATED_VALUE';
    const ID_INT_COMMAND = 'COMMAND';
    const CMD_STOP_SERVICE = 1;
    method onCreate; override;
    method onDestroy; override;
    method onBind(bindingIntent: Intent): IBinder; override;
    method onStartCommand(startIntent: Intent; &flags, startId: Integer): Integer; override;
  end;

  //Nested thread class that will periodically send messages to the activity
  ServiceThread nested in SampleService = public class(Thread)
  private
    owningService: SampleService;
  public
    constructor (theService: SampleService);
    method run; override;
  end;

  //Nested broadcast receiver that listens out for messages from the activity
  ServiceReceiver nested in SampleService = public class(BroadcastReceiver)
  private
    owningService: SampleService;
  public
    constructor (theService: SampleService);
    method onReceive(ctx: Context; receivedIntent: Intent); override;
  end;

implementation

method SampleService.onCreate;
begin
  inherited;
  Log.i(TAG, 'Service onCreate');
  //Set up the service's broadcast receiver
  receiver := new ServiceReceiver(self);
end;

method SampleService.onDestroy;
begin
  Log.i(TAG, 'Service onDestroy');
  //Shut down the service's broadcast receiver
  unregisterReceiver(receiver);
  inherited
end;

method SampleService.onBind(bindingIntent: Intent): IBinder;
begin
  exit nil
end;

method SampleService.onStartCommand(startIntent: Intent; &flags: Integer; startId: Integer): Integer;
begin
  Log.i(TAG, 'Service onStartCommand');
  //Bear in mind the activity could call startService more than once, so we need to filter out subsequent invocations
  if not running then
  begin
    //Register the service's broadcast receiver which will pick up messages from the activity
    var filter := new IntentFilter;
    filter.addAction(ServiceInteractionActivity.SAMPLE_ACTIVITY_ACTION);
    registerReceiver(receiver, filter);
    //Now get the service thread up and running
    running := true;
    //Extract information passed along to the service
    startValue := startIntent.IntExtra[ID_INT_START_VALUE, 1];
    //Kickstart the service worker thread
    var myThread := new ServiceThread(self);
    myThread.start;
  end;
  exit inherited;
end;

constructor SampleService.ServiceThread(theService: SampleService);
begin
  inherited constructor;
  owningService := theService;
end;

//Thread body that sends a message to the activity every 5 seconds
method SampleService.ServiceThread.run;
begin
  var i := 1;
  while owningService.running do
    try
      Thread.sleep(5000);
      var activityIntent := new Intent;
      activityIntent.Action := SAMPLE_SERVICE_ACTION;
      //Package up a couple of pieces of information in the intent message
      activityIntent.putExtra(ID_INT_ITERATION, i);
      activityIntent.putExtra(ID_INT_CALCULATED_VALUE, i + owningService.startValue);
      if owningService.running then
        owningService.sendBroadcast(activityIntent);
      inc(i);
      Log.i(TAG, 'Sent a message from service to activity');
    except
      on InterruptedException do
        //nothing
    end;
  owningService.stopSelf
end;

constructor SampleService.ServiceReceiver(theService: SampleService);
begin
  inherited constructor;
  owningService := theService;
end;

//If the broadcast receiver receives a stop command then stop the worker thread and the service
method SampleService.ServiceReceiver.onReceive(ctx: Context; receivedIntent: Intent);
begin
  var cmd := receivedIntent.IntExtra[ID_INT_COMMAND, 0];
  if cmd = CMD_STOP_SERVICE then
  begin
    owningService.running := false;
    owningService.stopSelf;
    Toast.makeText(owningService, 'Service stopped by main activity', Toast.LENGTH_LONG).show
  end;
end;

end.