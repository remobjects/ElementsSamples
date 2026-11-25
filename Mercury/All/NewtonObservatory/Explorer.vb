Namespace Global.NewtonObservatory
  Class Explorer
    Public Shared Sub Draw(frame As TerminalFrame, x As Double, y As Double, zoom As Double)
      If frame.Columns < 16 OrElse frame.Rows < 7 Then
        frame.Clear()
        If frame.Columns >= 24 Then
          frame.WriteLine(1, "Enlarge window; Q quits.")
          Return
        End If
        frame.WriteLine(1, "Resize / Q")
        Return
      End If
      Dim width As Int32 = frame.Columns - 2
      Dim height As Int32 = frame.Rows - 4
      Dim plate As Exposure = Observatory.RenderViewport(width, height, x, y, zoom)
      Dim controls As String = "Arrows: pan  +/-: zoom  R: reset  Q: quit"
      Dim title As String = "NEWTON OBSERVATORY / z^3 - 1  |  "
      If frame.Columns >= title.Length + controls.Length Then
        controls = title + controls
      End If
      If frame.Columns < controls.Length Then
        controls = "Arrows +/- R Q"
      End If
      frame.WriteLine(1, controls)
      Dim rule As String = "+".PadEnd(width + 1, "-"c) + "+"
      frame.WriteLine(2, rule)
      Dim row As Int32 = 0
      While row < height
        frame.WriteLine(row + 3, "|" + plate.Rows(row) + "|")
        row = row + 1
      End While
      frame.WriteLine(frame.Rows - 1, rule)
      Dim percent As Int32 = DirectCast(zoom * 100, Int32)
      Dim view As String = Convert.ToString(width) + "x" + Convert.ToString(height) + "  Zoom " + Convert.ToString(percent) + "%"
      Dim status As String = view + "  |  @E " + Convert.ToString(plate.RootCounts(0)) + "  ON " + Convert.ToString(plate.RootCounts(1)) + "  WS " + Convert.ToString(plate.RootCounts(2)) + "  ? " + Convert.ToString(plate.UnresolvedCount)
      If status.Length > frame.Columns Then
        status = view
      End If
      If status.Length > frame.Columns Then
        status = Convert.ToString(width) + "x" + Convert.ToString(height) + " " + Convert.ToString(percent) + "%"
      End If
      frame.WriteLine(frame.Rows, status)
    End Sub

    Public Shared Sub Navigate()
      Dim x As Double = 0.0
      Dim y As Double = 0.0
      Dim zoom As Double = 1.0
      Do
        Dim key As Int32 = Terminal.ReadKey(Sub(frame) Draw(frame, x, y, zoom))
        If key = Terminal.UpArrow Then
          y = y + 0.42 / zoom
        End If
        If key = Terminal.DownArrow Then
          y = y - 0.42 / zoom
        End If
        If key = Terminal.LeftArrow Then
          x = x - 0.36 / zoom
        End If
        If key = Terminal.RightArrow Then
          x = x + 0.36 / zoom
        End If
        ' + or = zooms in.
        If (key = 43 OrElse key = 61) AndAlso zoom < 100 Then
          zoom = zoom * 1.25
        End If
        ' - or _ zooms out.
        If (key = 45 OrElse key = 95) AndAlso zoom > 0.125 Then
          zoom = zoom / 1.25
        End If
        ' R resets the view.
        If key = 82 OrElse key = 114 Then
          x = 0.0
          y = 0.0
          zoom = 1.0
        End If
        ' Q, Ctrl+C, Ctrl+D or end of input closes the view.
        If key = 81 OrElse key = 113 OrElse key = 3 OrElse key = 4 OrElse key = Terminal.EndOfInput Then
          Return
        End If
      Loop
    End Sub

    Public Shared Function Run() As Int32
#If COOPER Then
      If JvmConsole.Run() Then Return 0
#Else
      If Terminal.RunFullScreen(AddressOf Navigate) Then Return 0
#End If
      writeLn("--explore requires interactive terminal input and output.")
      Return 1
    End Function
  End Class
End Namespace
