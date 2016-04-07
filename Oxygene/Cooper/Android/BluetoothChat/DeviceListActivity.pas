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
  java.util,
  android.app, 
  android.bluetooth,
  android.content,
  android.os,
  android.util,
  android.view,
  android.widget;

type
(**
 * This Activity appears as a dialog. It lists any paired devices and
 * devices detected in the area after discovery. When a device is chosen
 * by the user, the MAC address of the device is sent back to the parent
 * Activity in the result Intent.
 *)
  DeviceListActivity = public class(Activity)
  private
    //  Debugging
    const TAG = 'DeviceListActivity';
    const D = true;
    //  Member fields
    var mReceiver: BluetoothBroadcastReceiver;
    var mBtAdapter: BluetoothAdapter;
    var mPairedDevicesArrayAdapter: ArrayAdapter<String>;
    // The on-click listener for all devices in the ListViews
    var mDeviceClickListener: ListView.OnItemClickListener;
    method doDiscovery;
  protected
    method onCreate(savedInstanceState: Bundle); override;
    method onDestroy; override;
  public
    //  Return Intent extra
    const EXTRA_DEVICE_ADDRESS = 'device_address';
    var mNewDevicesArrayAdapter: ArrayAdapter<String>;
  end;

  // The BroadcastReceiver that listens for discovered devices and
  // changes the title when discovery is finished
  BluetoothBroadcastReceiver nested in DeviceListActivity = public class(BroadcastReceiver)
  private
    var mActivity: DeviceListActivity;
  public
    constructor(aActivity: DeviceListActivity);
    method onReceive(aContext: Context; aIntent: Intent); override;
  end;

implementation

method DeviceListActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited onCreate(savedInstanceState);
  //  Setup the window
  requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
  ContentView := R.layout.device_list;
  //  Set result CANCELED in case the user backs out
  setResult(Activity.RESULT_CANCELED);
  //  Initialize the button to perform device discovery
  var scanButton: Button := Button(findViewById(R.id.button_scan));
  scanButton.OnClickListener := 
    method(v: View)
    begin
      doDiscovery();
      v.Visibility := View.GONE
    end;
  //  Initialize array adapters. One for already paired devices and
  //  one for newly discovered devices
  mPairedDevicesArrayAdapter := new ArrayAdapter<String>(self, R.layout.device_name);
  mNewDevicesArrayAdapter := new ArrayAdapter<String>(self, R.layout.device_name);

  mDeviceClickListener :=
    method(av: AdapterView<Adapter>; v: View; arg2: Integer; arg3: Int64)
    begin
      //  Cancel discovery because it's costly and we're about to connect
      mBtAdapter.cancelDiscovery;
      //  Get the device MAC address, which is the last 17 chars in the View
      var info: String := TextView(v).Text.toString;
      var address: String := info.substring(info.length - 17);
      //  Create the result Intent and include the MAC address
      var i: Intent := new Intent;
      i.putExtra(EXTRA_DEVICE_ADDRESS, address);
      //  Set result and finish this Activity
      setResult(Activity.RESULT_OK, i);
      finish;
    end;
  //  Find and set up the ListView for paired devices
  var pairedListView: ListView := ListView(findViewById(R.id.paired_devices));
  pairedListView.Adapter := mPairedDevicesArrayAdapter;
  pairedListView.OnItemClickListener := mDeviceClickListener;
  //  Find and set up the ListView for newly discovered devices
  var newDevicesListView: ListView := ListView(findViewById(R.id.new_devices));
  newDevicesListView.Adapter := mNewDevicesArrayAdapter;
  newDevicesListView.OnItemClickListener := mDeviceClickListener;
  //  Register for broadcasts when a device is discovered
  mReceiver := new BluetoothBroadcastReceiver(self);
  var filter: IntentFilter := new IntentFilter(BluetoothDevice.ACTION_FOUND);
  registerReceiver(mReceiver, filter);
  //  Register for broadcasts when discovery has finished
  filter := new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
  registerReceiver(mReceiver, filter);
  //  Get the local Bluetooth adapter
  mBtAdapter := BluetoothAdapter.DefaultAdapter;
  //  Get a set of currently paired devices
  var pairedDevices: &Set<BluetoothDevice> := mBtAdapter.BondedDevices;
  //  If there are paired devices, add each one to the ArrayAdapter
  if pairedDevices.size > 0 then
  begin
    findViewById(R.id.title_paired_devices).Visibility := View.VISIBLE;
    for each device: BluetoothDevice in pairedDevices do
      mPairedDevicesArrayAdapter.&add(device.Name + ''#10 + device.Address)
  end
  else
  begin
    var noDevices: String := Resources.String[R.string.none_paired];
    mPairedDevicesArrayAdapter.&add(noDevices)
  end
end;

method DeviceListActivity.onDestroy;
begin
  inherited onDestroy();
  //  Make sure we're not doing discovery anymore
  if mBtAdapter <> nil then
    mBtAdapter.cancelDiscovery;
  //  Unregister broadcast listeners
  unregisterReceiver(mReceiver)
end;

/// <summary>
/// Start device discover with the BluetoothAdapter
/// </summary>
method DeviceListActivity.doDiscovery;
begin
  if D then
    Log.d(TAG, 'doDiscovery()');
  //  Indicate scanning in the title
  ProgressBarIndeterminateVisibility := true;
  Title := R.string.scanning;
  //  Turn on sub-title for new devices
  findViewById(R.id.title_new_devices).Visibility := View.VISIBLE;
  //  If we're already discovering, stop it
  if mBtAdapter.isDiscovering then
    mBtAdapter.cancelDiscovery;
  //  Request discover from BluetoothAdapter
  mBtAdapter.startDiscovery
end;

constructor DeviceListActivity.BluetoothBroadcastReceiver(aActivity: DeviceListActivity);
begin
  inherited constructor;
  mActivity := aActivity;
end;

method DeviceListActivity.BluetoothBroadcastReceiver.onReceive(aContext: Context; aIntent: Intent);
begin
  var action: String := aIntent.Action;
  //  When discovery finds a device
  case action of
    BluetoothDevice.ACTION_FOUND:
    begin
      //  Get the BluetoothDevice object from the Intent
      var device: BluetoothDevice := aIntent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE);
      //  If it's already paired, skip it, because it's been listed already
      if device.BondState <> BluetoothDevice.BOND_BONDED then
        mActivity.mNewDevicesArrayAdapter.&add(device.Name + ''#10 + device.Address)
    end;
    BluetoothAdapter.ACTION_DISCOVERY_FINISHED:
    begin
      mActivity.ProgressBarIndeterminateVisibility := false;
      mActivity.Title := R.string.select_device;
      if mActivity.mNewDevicesArrayAdapter.Count = 0 then
      begin
        var noDevices: String := aContext.Resources.Text[R.string.none_found].toString;
        mActivity.mNewDevicesArrayAdapter.&add(noDevices)
      end
    end;
  end;
end;

end.