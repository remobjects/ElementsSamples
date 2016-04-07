Sample app translation done by Brian Long (http://blong.com)

Portions of this demo are modifications based on work created and shared by
the Android Open Source Project and used according to terms described in
the Creative Commons 2.5 Attribution License.

The original version can be found at:

<Android SDK path>\android-sdk-windows\samples\android-<Android API level>\WiktionarySimple

The original Android SDK sample did not register an icon for the WordWidget
broadcast receiver in the Android manifest file. This is rectified in this
ported version.

To install the widget, build the Android package and then use the adb
Android SDK command-line tool to install it onto the device, e.g.:

adb install -t bin\Debug\com.example.android.simplewiktionary.apk

Then do as you normally do to install an Android homescreen widget.
This widget will be in the list as Wiktionary simple.

The widget reads the Wiktionary Word of the Day and writes it, along with
the first portion of the meaning on the desktop. However this is done in
black font so won't be visibly if you have a black homescreen.