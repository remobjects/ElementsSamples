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
  android.bluetooth,
  android.content, 
  android.os, 
  android.util, 
  android.widget;

type
  BluetoothChatService = public class
  private
    //  Debugging
    const TAG = 'BluetoothChatService';
    const D = true;
    //  Name for the SDP record when creating server socket
    const NAME_SECURE = 'BluetoothChatSecure';
    const NAME_INSECURE = 'BluetoothChatInsecure';
    //  Member fields
    var mSecureAcceptThread: AcceptThread;
	//NOTE: this thread won't get set up on Android versions that do not
	//support Bluetooth insecure connections (they were introduced in
	//Android 2.3.3 - API level 10)
    var mInsecureAcceptThread: AcceptThread;
    var mConnectedThread: ConnectedThread;
    //NOTE: this field is not in the original Android SDK demo. It has been introduced to fix a
    //bug whereby exiting the app recreates threads, which then get in the way if the app is
    //restarted - the UI doesn't see new connections made by those old threads
    var mStopping: Boolean := false;
    //  Member fields
    var mAdapter: BluetoothAdapter; readonly;
    var mConnectThread: ConnectThread;
    var mHandler: Handler; readonly;
    var mState: Integer;
    //  Unique UUID for this application
    var MY_UUID_SECURE: UUID := UUID.fromString('fa87c0d0-afac-11de-8a39-0800200c9a66'); readonly;
    var MY_UUID_INSECURE: UUID := UUID.fromString('8ce255c0-200a-11e0-ac64-0800200c9a66'); readonly;
    method setState(state: Integer); locked;
    method connectionFailed;
    method connectionLost;
  public
    var mContext: Context;
    //  Constants that indicate the current connection state
    const STATE_NONE = 0; //  we're doing nothing
    const STATE_LISTEN = 1; //  now listening for incoming connections
    const STATE_CONNECTING = 2; //  now initiating an outgoing connection
    const STATE_CONNECTED = 3; //  now connected to a remote device
    constructor (ctx: Context; hndlr: Handler);
    method getState: Integer; locked;
    method start; locked;
    method connect(device: BluetoothDevice; secure: Boolean); locked;
    method connected(socket: BluetoothSocket; device: BluetoothDevice; socketType: String); locked;
    method stop; locked;
    method &write(&out: array of SByte);
  end;

  /// <summary>
  /// This thread runs while listening for incoming connections. It behaves
  /// like a server-side client. It runs until a connection is accepted
  /// (or until cancelled).
  /// </summary>
  AcceptThread nested in BluetoothChatService = public class(Thread)
  private
    var mService: BluetoothChatService;
    //  The local server socket
    var mmServerSocket: BluetoothServerSocket; readonly;
    var mSocketType: String;
  public
    constructor (service: BluetoothChatService; secure: Boolean);
    method run; override;
    method cancel;
  end;

  /// <summary>
  /// This thread runs while attempting to make an outgoing connection
  /// with a device. It runs straight through; the connection either
  /// succeeds or fails.
  /// </summary>
  ConnectThread nested in BluetoothChatService = public class(Thread)
  private
    var mService: BluetoothChatService;
    var mmSocket: BluetoothSocket; readonly;
    var mmDevice: BluetoothDevice; readonly;
    var mSocketType: String;
  public
    constructor (service: BluetoothChatService; device: BluetoothDevice; secure: Boolean);
    method run; override;
    method cancel;
  end;

  /// <summary>
  /// This thread runs during a connection with a remote device.
  /// It handles all incoming and outgoing transmissions.
  /// </summary>
  ConnectedThread nested in BluetoothChatService = public class(Thread)
  private
    var mService: BluetoothChatService;
    var mmSocket: BluetoothSocket; readonly;
    var mmInStream: InputStream; readonly;
    var mmOutStream: OutputStream; readonly;
  public
    constructor (service: BluetoothChatService; socket: BluetoothSocket; socketType: String);
    method run; override;
    method cancel;
    method &write(buffer: array of SByte);
  end;


implementation

/// <summary>
/// Constructor. Prepares a new BluetoothChat session.
/// </summary>
/// <param name="ctx">The UI Activity Context</param>
/// <param name="hndlr">A Handler to send messages back to the UI Activity</param>
constructor BluetoothChatService(ctx: Context; hndlr: Handler);
begin
  mAdapter := BluetoothAdapter.DefaultAdapter;
  mState := STATE_NONE;
  mHandler := hndlr;
  mContext := ctx;
end;

/// <summary>
/// Set the current state of the chat connection
/// </summary>
/// <param name="state">An integer defining the current connection state</param>
method BluetoothChatService.setState(state: Integer);
begin
  if D then
    Log.d(TAG, 'setState() ' + mState + ' -> ' + state);
  mState := state;
  //  Give the new state to the Handler so the UI Activity can update
  mHandler.obtainMessage(BluetoothChat.MESSAGE_STATE_CHANGE, state, - 1).sendToTarget;
end;

/// <summary>
/// Indicate that the connection attempt failed and notify the UI Activity.
/// </summary>
method BluetoothChatService.connectionFailed;
begin
  var msg: Message := mHandler.obtainMessage(BluetoothChat.MESSAGE_TOAST);
  var bundle: Bundle := new Bundle();
  bundle.putString(BluetoothChat.TOAST_MSG, 'Unable to connect device');
  msg.Data := bundle;
  mHandler.sendMessage(msg);
  //  Start the service over to restart listening mode
  start;
end;

/// <summary>
/// Indicate that the connection was lost and notify the UI Activity.
/// </summary>
method BluetoothChatService.connectionLost;
begin
  var msg: Message := mHandler.obtainMessage(BluetoothChat.MESSAGE_TOAST);
  var bundle: Bundle := new Bundle();
  bundle.putString(BluetoothChat.TOAST_MSG, 'Device connection was lost');
  msg.Data := bundle;
  mHandler.sendMessage(msg);
  //  Start the service over to restart listening mode
  start;
end;

/// <summary>
/// Return the current connection state.
/// </summary>
/// <returns></returns>
method BluetoothChatService.getState: Integer;
begin
  exit mState
end;

/// <summary>
/// Start the chat service. Specifically start AcceptThread to begin a
/// session in listening (server) mode. Called by the Activity onResume()
/// </summary>
method BluetoothChatService.start;
begin
  if mStopping then
    exit;
  if D then
    Log.d(TAG, 'start');
  //  Cancel any thread attempting to make a connection
  if mConnectThread <> nil then
  begin
    mConnectThread.cancel;
    mConnectThread := nil
  end;
  //  Cancel any thread currently running a connection
  if mConnectedThread <> nil then
  begin
    mConnectedThread.cancel;
    mConnectedThread := nil
  end;
  setState(STATE_LISTEN);
  //  Start the thread to listen on a BluetoothServerSocket
  if mSecureAcceptThread = nil then
  begin
    mSecureAcceptThread := new AcceptThread(self, true);
    mSecureAcceptThread.start
  end;
  //NOTE: only set up the insecure connection thread if the Android
  //version supports insecure connections
  if Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD_MR1 then
    if mInsecureAcceptThread = nil then
    begin
      mInsecureAcceptThread := new AcceptThread(self, false);
      mInsecureAcceptThread.start
    end;
end;

/// <summary>
/// Start the ConnectThread to initiate a connection to a remote device.
/// </summary>
/// <param name="device">The BluetoothDevice to connect</param>
/// <param name="secure">Socket Security type - Secure (true) , Insecure (false)</param>
method BluetoothChatService.connect(device: BluetoothDevice; secure: Boolean);
begin
  if D then
    Log.d(TAG, ('connect to: ' + device));
  //  Cancel any thread attempting to make a connection
  if mState = STATE_CONNECTING then
  begin
    if mConnectThread <> nil then
    begin
      mConnectThread.cancel;
      mConnectThread := nil
    end
  end;
  //  Cancel any thread currently running a connection
  if mConnectedThread <> nil then
  begin
    mConnectedThread.cancel;
    mConnectedThread := nil
  end;
  //  Start the thread to connect with the given device
  mConnectThread := new ConnectThread(self, device, secure);
  mConnectThread.start;
  setState(STATE_CONNECTING);
end;

/// <summary>
/// Start the ConnectedThread to begin managing a Bluetooth connection
/// </summary>
/// <param name="socket">The BluetoothSocket on which the connection was made</param>
/// <param name="device">The BluetoothDevice that has been connected</param>
/// <param name="socketType"></param>
method BluetoothChatService.connected(socket: BluetoothSocket; device: BluetoothDevice; socketType: String);
begin
  if D then
    Log.d(TAG, 'connected, Socket Type: ' + socketType);
  //  Cancel the thread that completed the connection
  if mConnectThread <> nil then
  begin
    mConnectThread.cancel;
    mConnectThread := nil
  end;
  //  Cancel any thread currently running a connection
  if mConnectedThread <> nil then
  begin
    mConnectedThread.cancel;
    mConnectedThread := nil
  end;
  //  Cancel the accept thread because we only want to connect to one device
  if mSecureAcceptThread <> nil then
  begin
    mSecureAcceptThread.cancel;
    mSecureAcceptThread := nil
  end;
  if mInsecureAcceptThread <> nil then
  begin
    mInsecureAcceptThread.cancel;
    mInsecureAcceptThread := nil
  end;
  //  Start the thread to manage the connection and perform transmissions
  mConnectedThread := new ConnectedThread(self, socket, socketType);
  mConnectedThread.start;
  //  Send the name of the connected device back to the UI Activity
  var msg: Message := mHandler.obtainMessage(BluetoothChat.MESSAGE_DEVICE_NAME);
  var bundle: Bundle := new Bundle;
  bundle.putString(BluetoothChat.DEVICE_NAME, device.Name);
  msg.Data := bundle;
  Log.i(TAG, 'Sending MESSAGE_DEVICE_NAME message');
  mHandler.sendMessage(msg);
  Log.i(TAG, 'Setting STATE_CONNECTED message');
  setState(STATE_CONNECTED);
end;

/// <summary>
/// Stop all threads
/// </summary>
method BluetoothChatService.stop;
begin
  if D then
    Log.d(TAG, 'stop');
  mStopping := true;
  if mConnectThread <> nil then
  begin
    mConnectThread.cancel;
    mConnectThread := nil
  end;
  if mConnectedThread <> nil then
  begin
    mConnectedThread.cancel;
    mConnectedThread := nil
  end;
  if mSecureAcceptThread <> nil then
  begin
    mSecureAcceptThread.cancel;
    mSecureAcceptThread := nil
  end;
  if mInsecureAcceptThread <> nil then
  begin
    mInsecureAcceptThread.cancel;
    mInsecureAcceptThread := nil
  end;
  setState(STATE_NONE);
end;

/// <summary>
/// Write to the ConnectedThread in an unsynchronized manner
/// </summary>
/// <param name="out">The bytes to write</param>
method BluetoothChatService.&write(&out: array of SByte);
begin
  //  Create temporary object
  var r: ConnectedThread;
  //  Synchronize a copy of the ConnectedThread
  locking self do 
  begin
    if mState <> STATE_CONNECTED then
      exit;
    r := mConnectedThread
  end;
  //  Perform the write unsynchronized
  r.&write(&out);
end;

/// <summary>
/// Write to the ConnectedThread in an unsynchronized manner
/// </summary>
/// <param name="out">The bytes to write</param>
/// <see>ConnectedThread#write(byte[])</see>
//TODO: seealso
constructor BluetoothChatService.AcceptThread(service: BluetoothChatService; secure: Boolean);
begin
  mService := service;
  var tmp: BluetoothServerSocket := nil;
  mSocketType := if secure then 'Secure' else 'Insecure';
  //  Create a new listening server socket
  try
    if secure then
      tmp := mService.mAdapter.listenUsingRfcommWithServiceRecord(NAME_SECURE, mService.MY_UUID_SECURE)
    else
    begin
	  //NOTE: extra check to make sure an API is not called
	  //on an Android version that does not support it
      if Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD_MR1 then
        tmp := mService.mAdapter.listenUsingInsecureRfcommWithServiceRecord(NAME_INSECURE, mService.MY_UUID_INSECURE)
      else
        Toast.makeText(mService.mContext, mService.mContext.String[R.string.no_insecure_support], Toast.LENGTH_LONG).show
    end
  except
    on e: IOException do 
      Log.e(TAG, 'Socket Type: ' + mSocketType + ' - listen() failed', e)
  end;
  mmServerSocket := tmp;
end;

method BluetoothChatService.AcceptThread.run;
begin
  if D then
    Log.d(TAG, 'Socket Type: ' + mSocketType + ' BEGIN mAcceptThread ' + self);
  Name := 'AcceptThread-' + mSocketType;
  var socket: BluetoothSocket := nil;
  //  Listen to the server socket if we're not connected
  while mService.mState <> STATE_CONNECTED do
  begin
    try
      //  This is a blocking call and will only return on a
      //  successful connection or an exception
      socket := mmServerSocket.accept;
    except
      on e: IOException do 
      begin
        Log.e(TAG, 'Socket Type: ' + mSocketType + ' - accept() failed', e);
        break
      end
    end;
    //  If a connection was accepted
    if socket <> nil then
      locking mService do 
        case mService.mState of
          STATE_LISTEN, STATE_CONNECTING: 
            //  Situation normal. Start the connected thread.
            mService.connected(socket, socket.RemoteDevice, mSocketType);
          STATE_NONE, STATE_CONNECTED: 
            //  Either not ready or already connected. Terminate new socket.
            try
              socket.close;
            except
              on e: IOException do 
                Log.e(TAG, 'Could not close unwanted socket', e)
            end;
          end
  end;
  if D then
    Log.i(TAG, ('END mAcceptThread, socket Type: ' + mSocketType));
end;

method BluetoothChatService.AcceptThread.cancel;
begin
  if D then
    Log.d(TAG, 'Socket Type ' + mSocketType + ' - cancel ' + self);
  try
    mmServerSocket.close;
  except
    on e: IOException do 
      Log.e(TAG, 'Socket Type ' + mSocketType + ' - close() of server failed', e)
  end;
end;

constructor BluetoothChatService.ConnectThread(service: BluetoothChatService; device: BluetoothDevice; secure: Boolean);
begin
  mService := service;
  mmDevice := device;
  var tmp: BluetoothSocket := nil;
  mSocketType := if secure then 'Secure' else 'Insecure';
  //  Get a BluetoothSocket for a connection with the
  //  given BluetoothDevice
  try
    if secure then
      tmp := device.createRfcommSocketToServiceRecord(mService.MY_UUID_SECURE)
    else
    begin
	  //NOTE: extra check to make sure an API is not called
	  //on an Android version that does not support it
      if Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD_MR1 then
        tmp := device.createInsecureRfcommSocketToServiceRecord(mService.MY_UUID_INSECURE)
      else
        Toast.makeText(mService.mContext, mService.mContext.String[R.string.no_insecure_support], Toast.LENGTH_LONG).show
    end
  except
    on e: IOException do 
      Log.e(TAG, 'Socket Type: ' + mSocketType + ' - create() failed', e)
  end;
  mmSocket := tmp;
end;

method BluetoothChatService.ConnectThread.run;
begin
  Log.i(TAG, 'BEGIN mConnectThread SocketType: ' + mSocketType);
  Name := 'ConnectThread-' + mSocketType;
  //  Always cancel discovery because it will slow down a connection
  mService.mAdapter.cancelDiscovery;
  //  Make a connection to the BluetoothSocket
  try
    //  This is a blocking call and will only return on a
    //  successful connection or an exception
    mmSocket.connect;
  except
    on e: IOException do 
    begin
      //  Close the socket
      try
        mmSocket.close;
      except
        on e2: IOException do 
          Log.e(TAG, 'unable to close() ' + mSocketType + ' socket during connection failure', e2)
      end;
      mService.connectionFailed;
      exit
    end
  end;
  //  Reset the ConnectThread because we're done
  locking mService do 
    mService.mConnectThread := nil;
  //  Start the connected thread
  mService.connected(mmSocket, mmDevice, mSocketType);
end;

method BluetoothChatService.ConnectThread.cancel;
begin
  try
    mmSocket.close;
  except
    on e: IOException do 
      Log.e(TAG, 'close() of connect ' + mSocketType + ' socket failed', e)
  end;
end;

constructor BluetoothChatService.ConnectedThread(service: BluetoothChatService; socket: BluetoothSocket; socketType: String);
begin
  Log.d(TAG, 'create ConnectedThread: ' + socketType);
  Name := 'ConnectedThread-' + socketType;
  mService := service;
  mmSocket := socket;
  var tmpIn: InputStream := nil;
  var tmpOut: OutputStream := nil;
  //  Get the BluetoothSocket input and output streams
  try
    tmpIn := socket.InputStream;
    tmpOut := socket.OutputStream;
  except
    on e: IOException do 
      Log.e(TAG, 'temp sockets not created', e)
  end;
  mmInStream := tmpIn;
  mmOutStream := tmpOut;
end;

method BluetoothChatService.ConnectedThread.run;
begin
  Log.i(TAG, 'BEGIN mConnectedThread');
  var buffer := new SByte[1024];
  var bytes: Integer;
  //  Keep listening to the InputStream while connected
  while true do
    try
      //  Read from the InputStream
      bytes := mmInStream.&read(buffer);
      //  Send the obtained bytes to the UI Activity
      mService.mHandler.obtainMessage(BluetoothChat.MESSAGE_READ, bytes, - 1, buffer).sendToTarget;
    except
      on e: IOException do 
      begin
        Log.e(TAG, 'disconnected', e);
        mService.connectionLost;
        break
      end
    end;
end;

method BluetoothChatService.ConnectedThread.&write(buffer: array of SByte);
begin
  try
    mmOutStream.&write(buffer);
    //  Share the sent message back to the UI Activity
    mService.mHandler.obtainMessage(BluetoothChat.MESSAGE_WRITE, - 1, - 1, buffer).sendToTarget();
  except
    on e: IOException do 
      Log.e(TAG, 'Exception during write', e)
  end;
end;

method BluetoothChatService.ConnectedThread.cancel;
begin
  try
    mmSocket.close;
  except
    on e: IOException do 
      Log.e(TAG, 'close() of connect socket failed', e)
  end;
end;

end.