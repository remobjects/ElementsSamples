#If VCL Then
Imports Delphi.Vcl.Forms

Public Partial Class MainWindowController
  Private window As MainWindow

  Public Sub New()
    setup()
    Application.CreateForm(GetType(MainWindow), window)
    window.controller = Me
    window.ResultLabel.Caption = result
    AddHandler DirectCast(Me, RemObjects.Elements.System.INotifyPropertyChanged).PropertyChanged, Sub(sender, name)
      If name = "result" Then window.ResultLabel.Caption = result
    End Sub
  End Sub

  Public Sub showWindow(sender As id)
    window.Show()
  End Sub
End Class
#End If
