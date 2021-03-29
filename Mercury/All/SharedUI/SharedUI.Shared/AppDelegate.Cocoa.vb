#if TOFFEE Then
<NSApplicationMain>
<IBObject>
Public Partial Class AppDelegate
  Inherits INSApplicationDelegate

  Public Sub applicationDidFinishLaunching(notification As NSNotification)
	start()
  End Sub

  '
  ' Add Cocoa-specific code here
  '

End Class
#End If