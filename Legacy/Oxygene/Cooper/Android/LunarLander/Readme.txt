Sample app translation done by Brian Long (http://blong.com)

Portions of this demo are modifications based on work created and shared by
the Android Open Source Project and used according to terms described in
the Creative Commons 2.5 Attribution License.

The original version can be found at:

<Android SDK path>\android-sdk-windows\samples\android-<Android API level>\LunarLander

The original sample app's gameplay relies on the device having a D-Pad, which
more modern devices seem to lack, so the sample has been expanded to respond to
touches in triangular quadrants of the screen:

 - upper quadrant = D-Pad up
 - lower quadrant = D-Pad centre
 - left  quadrant = D-Pad left
 - right quadrant = D-Pad right

Note that this Android SDK sample had various bugs in the original Java version:

1) an illegal thread state exception when resuming the app thanks to trying to
start a thread that had already been started as discussed at:

http://stackoverflow.com/questions/672325
http://stackoverflow.com/questions/683136

This was fixed by changing the logic to pause the thread when switching away
from the app by making it wait on an object, and resuming it when returning by
notifying the thread it can continue.

2) the absence of nil-checking in LunarThread.run, leading to a
NullPointerException in doDraw() on some devices.

3) lack of saving game state along with other data, meaning that if you dies or
won then rotated the device, you would then be in a paused game state. When
you unpaused, you would immediately die or win again.