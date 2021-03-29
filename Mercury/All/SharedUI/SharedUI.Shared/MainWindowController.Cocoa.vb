#If TOFFEE Then
<IBObject>
Public Partial Class MainWindowController
  Inherits NSWindowController

  Public Sub New()
	MyBase.New(windowNibName: "MainWindow")
	setup()
  End Sub

  Public Overrides Sub windowDidLoad()
	MyBase.windowDidLoad()
	'  Implement this method to handle any initialization after your window controller's
	'  window has been loaded from its nib file.
  End Sub

  '
  ' Add Cocoa-Specific code here
  '

End Class
#End If