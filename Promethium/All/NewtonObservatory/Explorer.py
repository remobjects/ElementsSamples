def Draw(frame: TerminalFrame, x: float, y: float, zoom: float):
    if frame.Columns < 16 or frame.Rows < 7:
        frame.Clear()
        if frame.Columns >= 24:
            frame.WriteLine(1, "Enlarge window; Q quits.")
            return
        frame.WriteLine(1, "Resize / Q")
        return
    width: int = frame.Columns - 2
    height: int = frame.Rows - 4
    plate: Exposure = RenderRegion(width, height, -(width // 2), -(height // 2), x, y, zoom)
    controls: str = "Arrows: pan  +/-: zoom  R: reset  Q: quit"
    title: str = "NEWTON OBSERVATORY / z^3 - 1  |  "
    if frame.Columns >= title.Length + controls.Length:
        controls = title + controls
    if frame.Columns < controls.Length:
        controls = "Arrows +/- R Q"
    frame.WriteLine(1, controls)
    rule: str = "+" + "-" * width + "+"
    frame.WriteLine(2, rule)
    row: int = 0
    while row < height:
        frame.WriteLine(row + 3, "|" + plate.Rows[row] + "|")
        row = row + 1
    frame.WriteLine(frame.Rows - 1, rule)
    percent: int = Convert.ToInt32(Math.Truncate(zoom * 100))
    view: str = Convert.ToString(width) + "x" + Convert.ToString(height) + "  Zoom " + Convert.ToString(percent) + "%"
    status: str = view + "  |  @E " + Convert.ToString(plate.RootCounts[0]) + "  ON " + Convert.ToString(plate.RootCounts[1]) + "  WS " + Convert.ToString(plate.RootCounts[2]) + "  ? " + Convert.ToString(plate.UnresolvedCount)
    if status.Length > frame.Columns:
        status = view
    if status.Length > frame.Columns:
        status = Convert.ToString(width) + "x" + Convert.ToString(height) + " " + Convert.ToString(percent) + "%"
    frame.WriteLine(frame.Rows, status)

def Navigate():
    x: float = 0.0
    y: float = 0.0
    zoom: float = 1.0
    def draw_view(frame: TerminalFrame):
        Draw(frame, x, y, zoom)

    while True:
        key: int = Terminal.ReadKey(draw_view)
        if key == Terminal.UpArrow:
            y = y + 0.42 / zoom
        if key == Terminal.DownArrow:
            y = y - 0.42 / zoom
        if key == Terminal.LeftArrow:
            x = x - 0.36 / zoom
        if key == Terminal.RightArrow:
            x = x + 0.36 / zoom
        # + or = zooms in.
        if (key == 43 or key == 61) and zoom < 100:
            zoom = zoom * 1.25
        # - or _ zooms out.
        if (key == 45 or key == 95) and zoom > 0.125:
            zoom = zoom / 1.25
        # R resets the view.
        if key == 82 or key == 114:
            x = 0.0
            y = 0.0
            zoom = 1.0
        # Q, Ctrl+C, Ctrl+D or end of input closes the view.
        if key == 81 or key == 113 or key == 3 or key == 4 or key == Terminal.EndOfInput:
            return

def Run() -> int:
    if start_session():
        return 0
    print("--explore requires interactive terminal input and output.")
    return 1
