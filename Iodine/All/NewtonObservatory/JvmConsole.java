package NewtonObservatory;

final class JvmConsole {
  public static boolean Run() {
    if (java.lang.System.console() == null) return false;
    org.jline.terminal.Terminal device = org.jline.terminal.TerminalBuilder.builder().system(true).dumb(false).build();
    try {
      device.enterRawMode();
      return Terminal.RunFullScreen(device.writer(), () -> device.getRows(), () -> device.getColumns(),
                                    () -> device.reader().read(100), () -> Explorer.Navigate());
    } finally {
      device.close();
    }
  }
}
