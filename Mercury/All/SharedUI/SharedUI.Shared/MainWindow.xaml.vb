#If WPF Then
Imports System.Windows
Imports System.Windows.Controls
Public Partial Class MainWindow
  Inherits Window

  Private ReadOnly Property controller As MainWindowController
    Get
      Return CType(DataContext, MainWindowController)
    End Get
  End Property

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