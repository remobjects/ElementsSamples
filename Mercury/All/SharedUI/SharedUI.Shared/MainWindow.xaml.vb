#If ECHOES Then
Public Partial Class MainWindow
  Inherits Window

  Private Property controller As MainWindowController

  Public Sub New withController(controller As MainWindowController)

  DataContext = controller
  InitializeComponent()


  End Sub

  ' Forward actions to the controller
  Private Sub CalculateResult_Click(sender As Object, e As RoutedEventArgs)
	controller.calculateResult(sender)
  End Sub

End Class
#End If