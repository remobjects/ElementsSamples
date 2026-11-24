namespace NewtonObservatory
{
  static class Explorer
  {
    public static int Navigate(TerminalExplorer screen)
    {
      double x = 0.0, y = 0.0, zoom = 1.0;
      while (true)
      {
        switch (screen.NextAction(x, y, zoom))
        {
          case ExplorerAction.Left:
            x -= 0.36 / zoom;
            break;
          case ExplorerAction.Right:
            x += 0.36 / zoom;
            break;
          case ExplorerAction.Up:
            y += 0.42 / zoom;
            break;
          case ExplorerAction.Down:
            y -= 0.42 / zoom;
            break;
          case ExplorerAction.ZoomIn:
            if (zoom < 100)
              zoom *= 1.25;
            break;
          case ExplorerAction.ZoomOut:
            if (zoom > 0.125)
              zoom /= 1.25;
            break;
          case ExplorerAction.Reset:
            x = 0;
            y = 0;
            zoom = 1;
            break;
          case ExplorerAction.Quit:
            return 0;
        }
      }
    }
  }
}
