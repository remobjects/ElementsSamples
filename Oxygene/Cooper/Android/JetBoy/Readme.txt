Sample app translation done by Brian Long (http://blong.com)

Portions of this demo are modifications based on work created and shared by
the Android Open Source Project and used according to terms described in
the Creative Commons 2.5 Attribution License.

The original version can be found at:

<Android SDK path>\android-sdk-windows\samples\android-<Android API level>\JetBoy

This sampe demonstrates a game loop as well as SONiVOX' JET interactive music technology.
See http://d.android.com/reference/android/media/JetPlayer.html for more information.

The original sample app's gameplay relies on the device having a D-Pad, which
more modern devices seem to lack, so the sample has been expanded to respond to
touches on the screen to also control the ship firing.

Note that this Android SDK sample had various bugs in the original Java version:

1) an illegal thread state exception when resuming the app thanks to trying to
start a thread that had already been started.

This was fixed by changing the logic to pause the thread when switching away
from the app by making it wait on an object, and resuming it when returning by
notifying the thread it can continue.

2) The title screens are bitmaps which were not resized. This meant that on
modern larger screens the bitmaps covered only a portion of the screen.
This is rectified in JetBoyView.JetBoyThread.doDrawReady and
JetBoyView.JetBoyThread.doDrawPlay.

3) On larger displays the help text did not fit in the TextView thanks to the 
pixel size being fixed, but the font size being scaled. To fix this the 
TextView in main.xml has had its layout_width and layout_height
attributes adjusted from 300px to 300dp.

4) The protection beam was not stretched across the whole height of larger
displays. This is addressed in JetBoyView.JetBoyThread.doDrawRunning.

5) The volume key buttons were ignored during game play. This is addressed in
JetBoy.onKeyDown.

6) Some string resources were defined but then ignored in the original code
with literal strings being used instead