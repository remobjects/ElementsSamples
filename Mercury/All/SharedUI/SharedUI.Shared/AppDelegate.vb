Public Partial Class AppDelegate

  Public Property mainWindowController As MainWindowController

  Public Sub start()
	'
	'  this is the cross-platform entry point for the app
	'
	mainWindowController = New MainWindowController()
	mainWindowController.showWindow(Null)
  End Sub

  '
  ' Add Shared code here
  '

End Class