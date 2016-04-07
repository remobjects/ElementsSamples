Sample app translation done by Brian Long (http://blong.com)

Portions of this demo are modifications based on work created and shared by
the Android Open Source Project and used according to terms described in
the Creative Commons 2.5 Attribution License.

The original version can be found at:

<Android SDK path>\android-sdk-windows\samples\android-<Android API level>\BasicGLSurfaceView

This app uses OpenGL ES 2.0 and asserts this in the Android manifest
If uploaded to Google Play, the app would not be installable on devices
without this level of OpenGL.
If you install it on an emulator without suitable OpenGL support, it will
crash on startup similar to this:

D/libEGL(1477): egl.cfg not found, using default config
D/libEGL(1477): loaded /system/lib/egl/libGLES_android.so
I/ActivityManager(59): Displayed activity com.example.android.basicglsurfaceview/.BasicGLSurfaceViewActivity: 1048 ms (total 1048 ms)
W/dalvikvm(1477): threadid=7: thread exiting with uncaught exception (group=0x4001d800)
E/AndroidRuntime(1477): FATAL EXCEPTION: GLThread 8
E/AndroidRuntime(1477): java.lang.IllegalArgumentException: No configs match configSpec
E/AndroidRuntime(1477): 	at android.opengl.GLSurfaceView$BaseConfigChooser.chooseConfig(GLSurfaceView.java:760)
E/AndroidRuntime(1477): 	at android.opengl.GLSurfaceView$EglHelper.start(GLSurfaceView.java:916)
E/AndroidRuntime(1477): 	at android.opengl.GLSurfaceView$GLThread.guardedRun(GLSurfaceView.java:1246)
E/AndroidRuntime(1477): 	at android.opengl.GLSurfaceView$GLThread.run(GLSurfaceView.java:1116)
W/ActivityManager(59):   Force finishing activity com.example.android.basicglsurfaceview/.BasicGLSurfaceViewActivity

As of April 2012's Android SDK r17 update you can tweak an Android 4.0.3
emulator to have GPU support. In the Android AVD editing dialog, use the
Hardware settings and the New... button to add GPU emulation to the hardware
property list, and then set the property to 'yes':
http://android-developers.blogspot.co.uk/2012/04/faster-emulator-with-better-hardware.html