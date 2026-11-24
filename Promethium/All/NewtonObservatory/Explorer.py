def Navigate(screen: TerminalExplorer) -> int:
    x: float = 0.0
    y: float = 0.0
    zoom: float = 1.0
    while True:
        action: ExplorerAction = screen.NextAction(x, y, zoom)
        if action == ExplorerAction.Left:
            x -= 0.36 / zoom
        elif action == ExplorerAction.Right:
            x += 0.36 / zoom
        elif action == ExplorerAction.Up:
            y += 0.42 / zoom
        elif action == ExplorerAction.Down:
            y -= 0.42 / zoom
        elif action == ExplorerAction.ZoomIn and zoom < 100:
            zoom *= 1.25
        elif action == ExplorerAction.ZoomOut and zoom > 0.125:
            zoom /= 1.25
        elif action == ExplorerAction.Reset:
            x = 0
            y = 0
            zoom = 1
        elif action == ExplorerAction.Quit:
            return 0
