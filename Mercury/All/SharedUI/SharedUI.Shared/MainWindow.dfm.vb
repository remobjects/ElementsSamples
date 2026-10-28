#If VCL Then
Imports Delphi.System.Classes
Imports Delphi.Vcl.Forms
Imports Delphi.Vcl.Controls
Imports Delphi.Vcl.StdCtrls

Public Class MainWindow
  Inherits TForm

  Public Property controller As MainWindowController

  Public ReadOnly Property ResultLabel As TLabel
    Get
      Return CType(FindComponent("ResultLabel"), TLabel)
    End Get
  End Property

  <Published>
  Public Sub ValueAChanged(sender As TObject)
    If controller IsNot Nothing Then controller.valueA = CType(FindComponent("ValueAEdit"), TEdit).Text
  End Sub

  <Published>
  Public Sub ValueBChanged(sender As TObject)
    If controller IsNot Nothing Then controller.valueB = CType(FindComponent("ValueBEdit"), TEdit).Text
  End Sub

  <Published>
  Public Sub CalculateClick(sender As TObject)
    controller.calculateResult(Nothing)
  End Sub
End Class
#End If
