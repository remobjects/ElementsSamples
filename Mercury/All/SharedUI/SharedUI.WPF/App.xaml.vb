Imports System.Windows
Imports SharedUI.Shared

Public Partial Class App
  Inherits Application

  Private Dim appDelegate As AppDelegate

  Protected Overrides Sub OnStartup(e As StartupEventArgs)
	appDelegate = New AppDelegate()
	appDelegate.start()
  End Sub

End Class