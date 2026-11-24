Namespace Global.NewtonObservatory
  Module Explorer
    Public Function Navigate(screen As TerminalExplorer) As Int32
      Dim x As Double = 0.0
      Dim y As Double = 0.0
      Dim zoom As Double = 1.0
      Do
        Select Case screen.NextAction(x, y, zoom)
          Case ExplorerAction.Left
            x -= 0.36 / zoom
          Case ExplorerAction.Right
            x += 0.36 / zoom
          Case ExplorerAction.Up
            y += 0.42 / zoom
          Case ExplorerAction.Down
            y -= 0.42 / zoom
          Case ExplorerAction.ZoomIn
            If zoom < 100 Then zoom *= 1.25
          Case ExplorerAction.ZoomOut
            If zoom > 0.125 Then zoom /= 1.25
          Case ExplorerAction.Reset
            x = 0
            y = 0
            zoom = 1
          Case ExplorerAction.Quit
            Return 0
        End Select
      Loop
    End Function
  End Module
End Namespace
