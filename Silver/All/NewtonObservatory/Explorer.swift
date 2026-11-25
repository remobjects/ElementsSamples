final class Explorer {
  static func Draw(_ frame: TerminalFrame, _ x: Double, _ y: Double, _ zoom: Double) {
    if frame.Columns < 16 || frame.Rows < 7 {
      frame.Clear()
      if frame.Columns >= 24 {
        frame.WriteLine(1, "Enlarge window; Q quits.")
        return
      }
      frame.WriteLine(1, "Resize / Q")
      return
    }
    var width = frame.Columns - 2
    var height = frame.Rows - 4
    var plate = Observatory.RenderViewport(width, height, x, y, zoom)
    var controls = "Arrows: pan  +/-: zoom  R: reset  Q: quit"
    var title = "NEWTON OBSERVATORY / z^3 - 1  |  "
    if frame.Columns >= title.Length + controls.Length {
      controls = title + controls
    }
    if frame.Columns < controls.Length {
      controls = "Arrows +/- R Q"
    }
    frame.WriteLine(1, controls)
    var rule = "+".PadEnd(width + 1, "-") + "+"
    frame.WriteLine(2, rule)
    var row = 0
    while row < height {
      frame.WriteLine(row + 3, "|" + plate.Rows[row] + "|")
      row = row + 1
    }
    frame.WriteLine(frame.Rows - 1, rule)
    var percent = Int32(zoom * 100)
    var view = Convert.ToString(width) + "x" + Convert.ToString(height) + "  Zoom " + Convert.ToString(percent) + "%"
    var status = view + "  |  @E " + Convert.ToString(plate.RootCounts[0]) + "  ON " + Convert.ToString(plate.RootCounts[1]) + "  WS " + Convert.ToString(plate.RootCounts[2]) + "  ? " + Convert.ToString(plate.UnresolvedCount)
    if status.Length > frame.Columns {
      status = view
    }
    if status.Length > frame.Columns {
      status = Convert.ToString(width) + "x" + Convert.ToString(height) + " " + Convert.ToString(percent) + "%"
    }
    frame.WriteLine(frame.Rows, status)
  }

  static func Navigate() {
    var x = 0.0
    var y = 0.0
    var zoom = 1.0
    while true {
      var key = Terminal.ReadKey({ frame in Draw(frame, x, y, zoom) })
      if key == Terminal.UpArrow {
        y = y + 0.42 / zoom
      }
      if key == Terminal.DownArrow {
        y = y - 0.42 / zoom
      }
      if key == Terminal.LeftArrow {
        x = x - 0.36 / zoom
      }
      if key == Terminal.RightArrow {
        x = x + 0.36 / zoom
      }
      // + or = zooms in.
      if (key == 43 || key == 61) && zoom < 100 {
        zoom = zoom * 1.25
      }
      // - or _ zooms out.
      if (key == 45 || key == 95) && zoom > 0.125 {
        zoom = zoom / 1.25
      }
      // R resets the view.
      if key == 82 || key == 114 {
        x = 0.0
        y = 0.0
        zoom = 1.0
      }
      // Q, Ctrl+C, Ctrl+D or end of input closes the view.
      if key == 81 || key == 113 || key == 3 || key == 4 || key == Terminal.EndOfInput {
        return
      }
    }
  }

  static func Run() -> Int32 {
#if COOPER
    if JvmConsole.Run() { return 0 }
#else
    if Terminal.RunFullScreen({ Navigate() }) { return 0 }
#endif
    writeLn("--explore requires interactive terminal input and output.")
    return 1
  }
}
