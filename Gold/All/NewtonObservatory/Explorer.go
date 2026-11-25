package NewtonObservatory

func Draw(frame TerminalFrame, x Double, y Double, zoom Double) {
    if frame.Columns < 16 || frame.Rows < 7 {
        frame.Clear()
        if frame.Columns >= 24 {
            frame.WriteLine(1, "Enlarge window; Q quits.")
            return
        }
        frame.WriteLine(1, "Resize / Q")
        return
    }
    width := frame.Columns - 2
    height := frame.Rows - 4
    controls := "Arrows: pan  +/-: zoom  R: reset  Q: quit"
    title := "NEWTON OBSERVATORY / z^3 - 1  |  "
    if frame.Columns >= title.Length + controls.Length {
        controls = title + controls
    }
    if frame.Columns < controls.Length {
        controls = "Arrows +/- R Q"
    }
    frame.WriteLine(1, controls)
    rule := "+".PadEnd(width + 1, '-') + "+"
    frame.WriteLine(2, rule)
    RenderRegion(width, height, -(width / 2), -(height / 2), x, y, zoom, func(row Int32, text String) {
        frame.WriteLine(row + 3, "|" + text + "|")
    }, func(east, north, south, missing Int32) {
        frame.WriteLine(frame.Rows - 1, rule)
        percent := Int32(zoom * 100)
        view := Convert.ToString(width) + "x" + Convert.ToString(height) + "  Zoom " + Convert.ToString(percent) + "%"
        status := view + "  |  @E " + Convert.ToString(east) + "  ON " + Convert.ToString(north) + "  WS " + Convert.ToString(south) + "  ? " + Convert.ToString(missing)
        if status.Length > frame.Columns {
            status = view
        }
        if status.Length > frame.Columns {
            status = Convert.ToString(width) + "x" + Convert.ToString(height) + " " + Convert.ToString(percent) + "%"
        }
        frame.WriteLine(frame.Rows, status)
    })
}

func Navigate() {
    x := 0.0
    y := 0.0
    zoom := 1.0
    for {
        key := Terminal.ReadKey(func(frame TerminalFrame) { Draw(frame, x, y, zoom) })
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
        if (key == '+' || key == '=') && zoom < 100 {
            zoom = zoom * 1.25
        }
        if (key == '-' || key == '_') && zoom > 0.125 {
            zoom = zoom / 1.25
        }
        if key == 'R' || key == 'r' {
            x = 0.0
            y = 0.0
            zoom = 1.0
        }
        if key == 'Q' || key == 'q' || key == 3 || key == 4 || key == Terminal.EndOfInput {
            return
        }
    }
}

func Run() Int32 {
    if StartSession() {
        return 0
    }
    writeLn("--explore requires interactive terminal input and output.")
    return 1
}
