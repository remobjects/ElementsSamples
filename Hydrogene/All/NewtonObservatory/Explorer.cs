namespace NewtonObservatory {
  static class Explorer {
    public static void Draw(TerminalFrame frame, double x, double y, double zoom) {
      if (frame.Columns < 16 || frame.Rows < 7) {
        frame.Clear();
        if (frame.Columns >= 24) {
          frame.WriteLine(1, "Enlarge window; Q quits.");
          return;
        }
        frame.WriteLine(1, "Resize / Q");
        return;
      }
      int width = frame.Columns - 2;
      int height = frame.Rows - 4;
      Exposure plate = Observatory.RenderViewport(width, height, x, y, zoom);
      String controls = "Arrows: pan  +/-: zoom  R: reset  Q: quit";
      String title = "NEWTON OBSERVATORY / z^3 - 1  |  ";
      if (frame.Columns >= title.Length + controls.Length) {
        controls = title + controls;
      }
      if (frame.Columns < controls.Length) {
        controls = "Arrows +/- R Q";
      }
      frame.WriteLine(1, controls);
      String rule = "+".PadEnd(width + 1, '-') + "+";
      frame.WriteLine(2, rule);
      int row = 0;
      while (row < height) {
        frame.WriteLine(row + 3, "|" + plate.Rows[row] + "|");
        row = row + 1;
      }
      frame.WriteLine(frame.Rows - 1, rule);
      int percent = (int)(zoom * 100);
      String view = Convert.ToString(width) + "x" + Convert.ToString(height) + "  Zoom " + Convert.ToString(percent) + "%";
      String status = view + "  |  @E " + Convert.ToString(plate.RootCounts[0]) + "  ON " + Convert.ToString(plate.RootCounts[1]) + "  WS " + Convert.ToString(plate.RootCounts[2]) + "  ? " + Convert.ToString(plate.UnresolvedCount);
      if (status.Length > frame.Columns) {
        status = view;
      }
      if (status.Length > frame.Columns) {
        status = Convert.ToString(width) + "x" + Convert.ToString(height) + " " + Convert.ToString(percent) + "%";
      }
      frame.WriteLine(frame.Rows, status);
    }

    public static void Navigate() {
      double x = 0.0;
      double y = 0.0;
      double zoom = 1.0;
      while (true) {
        int key = Terminal.ReadKey(frame => Draw(frame, x, y, zoom));
        if (key == Terminal.UpArrow) {
          y = y + 0.42 / zoom;
        }
        if (key == Terminal.DownArrow) {
          y = y - 0.42 / zoom;
        }
        if (key == Terminal.LeftArrow) {
          x = x - 0.36 / zoom;
        }
        if (key == Terminal.RightArrow) {
          x = x + 0.36 / zoom;
        }
        if ((key == '+' || key == '=') && zoom < 100) {
          zoom = zoom * 1.25;
        }
        if ((key == '-' || key == '_') && zoom > 0.125) {
          zoom = zoom / 1.25;
        }
        if (key == 'R' || key == 'r') {
          x = 0.0;
          y = 0.0;
          zoom = 1.0;
        }
        if (key == 'Q' || key == 'q' || key == 3 || key == 4 || key == Terminal.EndOfInput) {
          return;
        }
      }
    }

    public static int Run() {
#if COOPER
      if (JvmConsole.Run()) return 0;
#else
      if (Terminal.RunFullScreen(() => Navigate())) return 0;
#endif
      writeLn("--explore requires interactive terminal input and output.");
      return 1;
    }
  }
}
