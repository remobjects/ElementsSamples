Namespace Global.NewtonObservatory

  Class Program

    Public Shared Function Main(aArgs As String()) As Int32
      For Each lArgument In aArgs
        If lArgument = "--explore" Then
          Return TerminalExplorer.Run
        End If
      Next
      Observatory.Run
      Return 0
    End Function

  End Class

End Namespace
