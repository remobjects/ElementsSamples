Sample app translation done by Brian Long (http://blong.com)

Portions of this demo are modifications based on work created and shared by
the Android Open Source Project and used according to terms described in
the Creative Commons 2.5 Attribution License.

The original version can be found at:

<Android SDK path>\android-sdk-windows\samples\android-<Android API level>\BluetoothChat

This translated example combines features from the API 15 version the example
as well as an older API level 8 version of the example.

When compiled for Android 3.0 and above (API 11 and above), this project uses the
Holo theme and so gets an ActionBar. Code in the app checks the running API level
and uses the ActionBar when appropriate.

Custom themes AppTheme and DialogTheme are defined differently based on the running platform
in values\styles.xml and values-v11\styles.xml to pull in the Holo
theme where available and a suitable theme where not.

The original demo had a bug whereby closing the app terminated but then recreated
the connection acceptance threads. These threads would still be around if you 
restarted the app and would prevent the UI noticing any new connection. This has
been fixed through the mStopping member field in BluetoothChatService.pas.

Additionally, the original demo Android manifest did not specify a minimum platform
nor state that it uses the Bluetooth radio feature. This app now states a 
minimum platform level of 5. However, insecure Bluetooth connections were
introduced in API level 10 (Android 2.3.3). So the menu used on lower Android
versions does not have the insecure connection option available. Additionally,
just to be thorough, the calls to
BluetoothAdapter.listenUsingInsecureRfcommWithServiceRecord() and
BluetoothDevice.createRfcommSocketToServiceRecord() are only allowed to be called
if running on Android 2.3.3 or later - on earlier versions a warning toast is
issued.

Also, the original demo used the occasional literal string, despite having a
quite well populated strings resource file.