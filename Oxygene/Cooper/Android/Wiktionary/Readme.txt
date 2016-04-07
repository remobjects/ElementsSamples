Sample app translation done by Brian Long (http://blong.com)

Portions of this demo are modifications based on work created and shared by
the Android Open Source Project and used according to terms described in
the Creative Commons 2.5 Attribution License.

The original version can be found at:

<Android SDK path>\android-sdk-windows\samples\android-<Android API level>\Wiktionary

The original Android SDK sample did not register an icon for the WordWidget
broadcast receiver in the Android manifest file. This is rectified in this
ported version.

To install the widget, build the Android package and then use the adb
Android SDK command-line tool to install it onto the device, e.g.:

adb install -t bin\Debug\com.example.android.wiktionary.apk

Then do as you normally do to install an Android homescreen widget.
This widget will be in the list as Wiktionary simple.

The widget reads the Wiktionary Word of the Day and writes it, along with
the first portion of the meaning on the desktop. Touching the widget
opens up a custom screen with the full definition and the ability to
search for other words.

The lack of pronunciation display is due to Android not having the required
IPA glyphs in its font, as per:
http://code.google.com/p/wiktionary-android/wiki/WhyNoPronunication?ts=1261004438&updated=WhyNoPronunication

TODO: need to consider menu options on devices with no menu button