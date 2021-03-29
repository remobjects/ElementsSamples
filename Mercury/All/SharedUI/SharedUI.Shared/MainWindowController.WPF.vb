#If ECHOES Then
Imports System.Windows

Public Partial Class MainWindowController

  Public ReadOnly Property window As Window

  Public Sub New()
	window = New MainWindow(withController := Me)
	setup()
  End Sub

  '
  ' Compatibility Helpers. These could/should be in a shared base class, in a real app with many window/views
  '
  Public Sub showWindow(sender As id)
	window.Show()
  End Sub

  '
  ' Add WPF-specific code here
  '

End Class
#End If