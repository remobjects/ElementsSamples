final class Explorer {
  static func Navigate(_ screen: TerminalExplorer) -> Int32 {
    var x = 0.0, y = 0.0, zoom = 1.0
    while true {
      switch screen.NextAction(x, y, zoom) {
      case .Left:
        x -= 0.36 / zoom
      case .Right:
        x += 0.36 / zoom
      case .Up:
        y += 0.42 / zoom
      case .Down:
        y -= 0.42 / zoom
      case .ZoomIn:
        if zoom < 100 { zoom *= 1.25 }
      case .ZoomOut:
        if zoom > 0.125 { zoom /= 1.25 }
      case .Reset:
        x = 0
        y = 0
        zoom = 1
      case .Quit:
        return 0
      default: break
      }
    }
  }
}
