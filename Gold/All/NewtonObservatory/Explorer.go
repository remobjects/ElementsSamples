package NewtonObservatory

func Navigate(screen TerminalExplorer) Int32 {
    x, y, zoom := 0.0, 0.0, 1.0
    for {
        switch screen.NextAction(x, y, zoom) {
        case ExplorerAction.Left:
            x -= 0.36 / zoom
        case ExplorerAction.Right:
            x += 0.36 / zoom
        case ExplorerAction.Up:
            y += 0.42 / zoom
        case ExplorerAction.Down:
            y -= 0.42 / zoom
        case ExplorerAction.ZoomIn:
            if zoom < 100 {
                zoom *= 1.25
            }
        case ExplorerAction.ZoomOut:
            if zoom > 0.125 {
                zoom /= 1.25
            }
        case ExplorerAction.Reset:
            x = 0
            y = 0
            zoom = 1
        case ExplorerAction.Quit:
            return 0
        }
    }
}
