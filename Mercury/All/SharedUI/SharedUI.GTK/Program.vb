Public Class Program
  Private Shared appDelegate As AppDelegate
  Public Shared application As Gtk.Application

  Public Shared Function Main(args As System.String()) As Int32
    application = Gtk.Application.New("com.remobjects.samples.sharedui", Gio.ApplicationFlags.FlagsNone)
    AddHandler application.OnActivate, Sub(sender, e)
      If appDelegate Is Nothing Then
        appDelegate = New AppDelegate()
        appDelegate.start()
      Else
        appDelegate.mainWindowController.showWindow(Nothing)
      End If
    End Sub
    Return application.RunWithSynchronizationContext(args)
  End Function
End Class
