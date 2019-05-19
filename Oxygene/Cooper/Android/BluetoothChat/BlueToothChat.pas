namespace com.example.android.bluetoothchat;

{*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *}

interface

uses
  java.io,
  java.util,
  android.app,
  android.bluetooth,
  android.content,
  android.os,
  android.util,
  android.view,
  android.view.inputmethod,
  android.widget;

type
  /// <summary>
  /// This is the main Activity that displays the current chat session.
  /// </summary>
  BluetoothChat = public class(Activity, Handler.Callback)
  private
    //  Debugging
    const TAG = 'BluetoothChat';
    const D = true;
    //  Intent request codes
    const REQUEST_CONNECT_DEVICE_SECURE = 1;
    const REQUEST_CONNECT_DEVICE_INSECURE = 2;
    const REQUEST_ENABLE_BT = 3;
    var mHandler: Handler;
    //  Layout Views
    var mTitle: TextView;
    var mConversationView: ListView;
    var mOutEditText: EditText;
    var mSendButton: Button;
    //  Name of the connected device
    var mConnectedDeviceName: String := nil;
    //  Array adapter for the conversation thread
    var mConversationArrayAdapter: ArrayAdapter<String>;
    //  String buffer for outgoing messages
    var mOutStringBuffer: StringBuffer;
    //  Local Bluetooth adapter
    var mBluetoothAdapter: BluetoothAdapter := nil;
    //  Member object for the chat services
    var mChatService: BluetoothChatService := nil;
    method setupChat;
    method ensureDiscoverable;
    method sendMessage(msg: String);
    method setStatus(resId: Integer);
    method setStatus(subTitle: CharSequence);
    method connectDevice(data: Intent; secure: Boolean);
    method handleMessage(msg: Message): Boolean;
  public
    //  Message types sent from the BluetoothChatService Handler
    const MESSAGE_STATE_CHANGE = 1;
    const MESSAGE_READ = 2;
    const MESSAGE_WRITE = 3;
    const MESSAGE_DEVICE_NAME = 4;
    const MESSAGE_TOAST = 5;
    //  Key names received from the BluetoothChatService Handler
    const DEVICE_NAME = 'device_name';
    const TOAST_MSG = 'toast';

    method onCreate(savedInstanceState: Bundle); override;
    method onStart; override;
    method onResume; override;
    method onPause; override;
    method onStop; override;
    method onDestroy; override;
    method onActivityResult(requestCode, resultCode: Integer; data: Intent); override;
    method onCreateOptionsMenu(mnu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
  end;

implementation

method BluetoothChat.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  if D then
    Log.e(TAG, '+++ ON CREATE +++');
  if Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB then
    //  Set up the window layout
    requestWindowFeature(Window.FEATURE_CUSTOM_TITLE);
  // Set our view from the "main" layout resource
  ContentView := R.layout.main;
  if Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB then
  begin
    Window.setFeatureInt(Window.FEATURE_CUSTOM_TITLE, R.layout.custom_title);
    //  Set up the custom title
    mTitle := TextView(findViewById(R.id.title_left_text));
    mTitle.Text := R.string.app_name;
  end;

  mHandler := new Handler(self);
  //  Get local Bluetooth adapter
  mBluetoothAdapter := BluetoothAdapter.DefaultAdapter;
  //  If the adapter is null, then Bluetooth is not supported
  if mBluetoothAdapter = nil then 
  begin
    Toast.makeText(self, String[R.string.no_bluetooth], Toast.LENGTH_LONG).show;
    finish;
    exit
  end;
end;

method BluetoothChat.onStart;
begin
  inherited;
  if D then
    Log.e(TAG, '++ ON START ++');
  //  If BT is not on, request that it be enabled.
  //  setupChat() will then be called during onActivityResult
  if not mBluetoothAdapter.isEnabled then
  begin
    var enableIntent: Intent := new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
    startActivityForResult(enableIntent, REQUEST_ENABLE_BT)
  end
  else
    if mChatService = nil then
      setupChat
end;

method BluetoothChat.onResume;
begin
  inherited;
  if D then
    Log.e(TAG, '+ ON RESUME +');
  //  Performing this check in onResume() covers the case in which BT was
  //  not enabled during onStart(), so we were paused to enable it...
  //  onResume() will be called when ACTION_REQUEST_ENABLE activity returns.
  if mChatService <> nil then
    //  Only if the state is STATE_NONE, do we know that we haven't started already
    if mChatService.getState = BluetoothChatService.STATE_NONE then
      //  Start the Bluetooth chat services
      mChatService.start
end;

method BluetoothChat.onPause;
begin
  inherited;
  if D then
    Log.e(TAG, '- ON PAUSE -');
end;

method BluetoothChat.onStop;
begin
  inherited;
  if D then
    Log.e(TAG, '-- ON STOP --');
end;

method BluetoothChat.onDestroy;
begin
  inherited;
  // Stop the Bluetooth chat services
  if mChatService <> nil then
    mChatService.stop;
  if D then
    Log.e(TAG, '--- ON DESTROY ---');
end;

method BluetoothChat.onActivityResult(requestCode: Integer; resultCode: Integer; data: Intent);
begin
  inherited;
  if D then
    Log.d(TAG, 'onActivityResult ' + resultCode);
  case requestCode of
    REQUEST_CONNECT_DEVICE_SECURE: 
        //  When DeviceListActivity returns with a device to connect
        if resultCode = Activity.RESULT_OK then
          connectDevice(data, true);
    REQUEST_CONNECT_DEVICE_INSECURE: 
        //  When DeviceListActivity returns with a device to connect
        if resultCode = Activity.RESULT_OK then
          connectDevice(data, false);
    REQUEST_ENABLE_BT: 
      begin
        //  When the request to enable Bluetooth returns
        if resultCode = Activity.RESULT_OK then
          //  Bluetooth is now enabled, so set up a chat session
          setupChat
        else
        begin
          //  User did not enable Bluetooth or an error occurred
          Log.d(TAG, 'BT not enabled');
          Toast.makeText(self, R.string.bt_not_enabled_leaving, Toast.LENGTH_SHORT).show;
          finish
        end
      end
  end ;
end;

method BluetoothChat.onCreateOptionsMenu(mnu: Menu): Boolean;
begin
  var inflater: MenuInflater := MenuInflater;
  inflater.inflate(R.menu.option_menu, mnu);
  exit true;
end;

method BluetoothChat.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  var serverIntent: Intent := nil;
  case item.ItemId of
    R.id.secure_connect_scan: 
      begin
        //  Launch the DeviceListActivity to see devices and do scan
        serverIntent := new Intent(self, typeOf(DeviceListActivity));
        startActivityForResult(serverIntent, REQUEST_CONNECT_DEVICE_SECURE);
        exit true
      end;
    R.id.insecure_connect_scan: 
      begin
        //  Launch the DeviceListActivity to see devices and do scan
        serverIntent := new Intent(self, typeOf(DeviceListActivity));
        startActivityForResult(serverIntent, REQUEST_CONNECT_DEVICE_INSECURE);
        exit true
      end;
    R.id.discoverable: 
      begin
        //  Ensure this device is discoverable by others
        ensureDiscoverable;
        exit true
      end;
  end;
  exit false;
end;

method BluetoothChat.setupChat;
begin
  Log.d(TAG, 'setupChat()');
  //  Initialize the array adapter for the conversation thread
  mConversationArrayAdapter := new ArrayAdapter<String>(self, R.layout.message);
  mConversationView := ListView(findViewById(R.id.list_in));
  mConversationView.Adapter := mConversationArrayAdapter;
  //  Initialize the compose field with a listener for the return key
  mOutEditText := EditText(findViewById(R.id.edit_text_out));
  mOutEditText.OnEditorActionListener := 
    method(view: TextView; actionId: Integer; &event: KeyEvent)
    begin
      //  If the action is a key-up event on the return key, send the message
      if (actionId = EditorInfo.IME_NULL) and (&event.Action = KeyEvent.ACTION_UP) then
      begin
        var message: String := view.Text.toString;
        sendMessage(message)
      end;
      if D then
        Log.i(TAG, 'END onEditorAction');
      exit true;
    end;
  //  Initialize the send button with a listener that for click events
  mSendButton := Button(findViewById(R.id.button_send));
  mSendButton.OnClickListener := 
    method (v: View)
    begin
      //  Send a message using content of the edit text widget
      var view: TextView := TextView(findViewById(R.id.edit_text_out));
      var message: String := view.Text.toString;
      sendMessage(message)
    end;
  //  Initialize the BluetoothChatService to perform bluetooth connections
  mChatService := new BluetoothChatService(self, mHandler);
  //  Initialize the buffer for outgoing messages
  mOutStringBuffer := new StringBuffer('');
end;

method BluetoothChat.ensureDiscoverable;
begin
  if D then
    Log.d(TAG, 'ensure discoverable');
  if mBluetoothAdapter.ScanMode <> BluetoothAdapter.SCAN_MODE_CONNECTABLE_DISCOVERABLE then
  begin
    var discoverableIntent: Intent := new Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE);
    discoverableIntent.putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, 300);
    startActivity(discoverableIntent)
  end;
end;

/// <summary>
/// Sends a message.
/// </summary>
/// <param name="msg">A string of text to send.</param>
method BluetoothChat.sendMessage(msg: String);
begin
  if mChatService.getState <> BluetoothChatService.STATE_CONNECTED then
  begin
    Toast.makeText(self, R.string.not_connected, Toast.LENGTH_SHORT).show;
    exit
  end;
  //  Check that there's actually something to send
  if msg.length > 0 then
  begin
    //  Get the message bytes and tell the BluetoothChatService to write
    var send: array of SByte := msg.Bytes;
    mChatService.&write(send);
    //  Reset out string buffer to zero and clear the edit text field
    mOutStringBuffer.Length := 0;
    mOutEditText.setText(mOutStringBuffer);
  end;
end;

method BluetoothChat.setStatus(resId: Integer);
begin
  var actionBar: ActionBar := self.ActionBar;
  actionBar.Subtitle := resId;
end;

method BluetoothChat.setStatus(subTitle: CharSequence);
begin
  var actionBar: ActionBar := self.ActionBar;
  actionBar.Subtitle := subTitle;
end;

method BluetoothChat.connectDevice(data: Intent; secure: Boolean);
begin
  //  Get the device MAC address
  var address: String := data.Extras.String[DeviceListActivity.EXTRA_DEVICE_ADDRESS];
  //  Get the BluetoothDevice object
  var device: BluetoothDevice := mBluetoothAdapter.RemoteDevice[address];
  //  Attempt to connect to the device
  mChatService.connect(device, secure);
end;

// The Handler that gets information back from the BluetoothChatService
method BluetoothChat.handleMessage(msg: Message): Boolean;
begin
  case msg.what of
    MESSAGE_STATE_CHANGE: 
      begin
        if D then
          Log.i(TAG, 'MESSAGE_STATE_CHANGE: ' + msg.arg1);
        case msg.arg1 of
          BluetoothChatService.STATE_CONNECTED: 
          begin
            if Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB then
              setStatus(getString(R.string.title_connected_to, mConnectedDeviceName))
            else
              mTitle.Text := getString(R.string.title_connected_to, mConnectedDeviceName);
            mConversationArrayAdapter.clear
          end;
          BluetoothChatService.STATE_CONNECTING:
          begin
            if Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB then
              setStatus(R.string.title_connecting)
            else
              mTitle.Text := R.string.title_connecting;
          end;
          BluetoothChatService.STATE_LISTEN,
          BluetoothChatService.STATE_NONE: 
          begin
            if Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB then
              setStatus(R.string.title_not_connected)
            else
              mTitle.Text := R.string.title_not_connected;
          end;
        end 
      end;
    MESSAGE_WRITE: 
      begin
        var writeBuf := array of SByte(msg.obj);
        // construct a string from the buffer
        var writeMessage := new String(writeBuf);
        mConversationArrayAdapter.&add('Me:  ' + writeMessage)
      end;
    MESSAGE_READ: 
      begin
        var readBuf := array of SByte(msg.obj);
        // construct a string from the valid bytes in the buffer
        var readMessage := new String(readBuf, 0, msg.arg1);
        mConversationArrayAdapter.&add(mConnectedDeviceName + ':  ' + readMessage)
      end;
    MESSAGE_DEVICE_NAME: 
      begin
        //  save the connected device's name
        mConnectedDeviceName := msg.Data.String[DEVICE_NAME];
        Toast.makeText(ApplicationContext, 'Connected to ' + mConnectedDeviceName, Toast.LENGTH_SHORT).show
      end;
    MESSAGE_TOAST: 
      Toast.makeText(ApplicationContext, msg.Data.String[TOAST_MSG], Toast.LENGTH_SHORT).show;
   end;
end;

end.