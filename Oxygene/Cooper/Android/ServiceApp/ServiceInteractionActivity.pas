namespace org.me.serviceapp;

//Sample app by Brian Long (http://blong.com)

{
  This example shows an activity interacting with a service (both ways)
  via intents and broadcast receivers.

  This file defines the main activity and its broadcast receiver.
  The activity invokes the service and can later tell it to stop by sending it an intent.
  When initially invoked, a value is passed along to the service.

  The activity's broadcast receiver picks up intent messages from the service
  when the activity is not stopped.
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
  ServiceInteractionActivity = public class(Activity)
  private
    const TAG = 'SvcAppActivity';
    var receiver: ActivityReceiver;
    var stopServiceButton: Button;
  public
    const SAMPLE_ACTIVITY_ACTION = 'SAMPLE_ACTIVITY_ACTION';
    method onCreate(savedInstanceState: Bundle); override;
    method onDestroy; override;
    method onStart; override;
    method onStop; override;
    method stopServiceButtonClick(v: View);
  end;

  //Nested broadcast receiver that listens out for messages from the service
  ActivityReceiver nested in ServiceInteractionActivity = public class(BroadcastReceiver)
  private
    owningActivity: ServiceInteractionActivity;
  public
    constructor (theActivity: ServiceInteractionActivity);
    method onReceive(ctx: Context; receivedIntent: Intent); override;
  end;

implementation

method ServiceInteractionActivity.onCreate(savedInstanceState: Bundle);
begin
  Log.i(TAG, 'Activity onCreate');
  inherited;
  // Set our view from the "main" layout resource
  ContentView := R.layout.main;
  stopServiceButton := Button(findViewById(R.id.stopServiceButton));
  if stopServiceButton <> nil then
    stopServiceButton.OnClickListener := @stopServiceButtonClick;
  receiver := new ActivityReceiver(self);
end;

//Make sure that if the activity dies then the service is also stopped
method ServiceInteractionActivity.onDestroy;
begin
  stopServiceButtonClick(stopServiceButton);
  inherited;
end;

//Note that if the user presses the Home button, this activity will stop, but not (necessarily) be destroyed
//If they use a long press on Home to re-visit this app, the activity will start
//This means we'll call startService again, despite not having stopped the service
//That's ok though - there'll be just one instance of the service,
//and it can decide if it needs to do anything in its onStartCommand
method ServiceInteractionActivity.onStart;
begin
  Log.i(TAG, 'Activity onStart');
  //Register the activity's broadcast receiver which will pick up messages from the service
  var filter := new IntentFilter;
  filter.addAction(SampleService.SAMPLE_SERVICE_ACTION);
  registerReceiver(receiver, filter);

  //Start the service
  var serviceIntent := new Intent(self, typeOf(SampleService));
  serviceIntent.putExtra(SampleService.ID_INT_START_VALUE, 10);
  startService(serviceIntent);
  inherited
end;

method ServiceInteractionActivity.onStop;
begin
  Log.i(TAG, 'Activity onStop');
  //Shut down the broadcast receiver
  unregisterReceiver(receiver);
  inherited
end;

//Send the service a command telling it to shut down
method ServiceInteractionActivity.stopServiceButtonClick(v: View);
begin
  var i := new Intent;
  i.Action := SAMPLE_ACTIVITY_ACTION;
  i.putExtra(SampleService.ID_INT_COMMAND, SampleService.CMD_STOP_SERVICE);
  sendBroadcast(i)
end;

constructor ServiceInteractionActivity.ActivityReceiver(theActivity: ServiceInteractionActivity);
begin
  inherited constructor;
  owningActivity := theActivity;
end;

//Receive messages from the service and display a toast describing the passed information
method ServiceInteractionActivity.ActivityReceiver.onReceive(ctx: Context; receivedIntent: Intent);
begin
  var iteration := receivedIntent.IntExtra[SampleService.ID_INT_ITERATION, 0];
  var calculatedValue := receivedIntent.IntExtra[SampleService.ID_INT_CALCULATED_VALUE, 0];
  Toast.makeText(owningActivity, 
    'Received call ' + String.valueOf(iteration) + ' from service'#10 +
    'with calculated value ' + String.valueOf(calculatedValue), Toast.LENGTH_SHORT).show
end;

end.