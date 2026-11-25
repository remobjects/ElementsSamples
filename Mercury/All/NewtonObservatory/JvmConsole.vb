Namespace Global.NewtonObservatory
  Class JvmConsole
    Public Shared Function Run() As Boolean
      If java.lang.System.console() Is Nothing Then Return False
      Dim device = org.jline.terminal.TerminalBuilder.builder().system(True).dumb(False).build()
      Try
        device.enterRawMode()
        Return Terminal.RunFullScreen(device.writer(), Function() device.getRows(), Function() device.getColumns(), Function() device.reader().read(100), AddressOf Explorer.Navigate)
      Finally
        device.close()
      End Try
    End Function
  End Class
End Namespace
