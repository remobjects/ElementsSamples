namespace NewtonObservatory {
  static class JvmConsole {
    public static bool Run() {
      if (java.lang.System.console() == null) return false;
      org.jline.terminal.Terminal device = org.jline.terminal.TerminalBuilder.builder().system(true).dumb(false).build();
      try {
        device.enterRawMode();
        return Terminal.RunFullScreen(device.writer(), () => device.getRows(), () => device.getColumns(),
                                      () => device.reader().read(100), () => Explorer.Navigate());
      } finally {
        device.close();
      }
    }
  }
}
