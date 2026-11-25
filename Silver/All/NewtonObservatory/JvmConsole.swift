final class JvmConsole {
  static func Run() -> Boolean {
    if java.lang.System.console() == nil { return false }
    let device = org.jline.terminal.TerminalBuilder.builder().system(true).dumb(false).build()
    defer { device.close() }
    device.enterRawMode()
    return Terminal.RunFullScreen(device.writer(), { device.getRows() }, { device.getColumns() },
                                  { device.reader().read(100) }, { Explorer.Navigate() })
  }
}
