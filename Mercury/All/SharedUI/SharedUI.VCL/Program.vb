Imports Delphi.Vcl.Forms

Public Class Program
  ' Retain the shared Island controller while VCL owns the native form.
  Private Shared appDelegate As AppDelegate

  Public Shared Sub Main()
    Application.Initialize()
    Application.MainFormOnTaskBar = True
    appDelegate = New AppDelegate()
    appDelegate.start()
    Application.Run()
  End Sub
End Class
