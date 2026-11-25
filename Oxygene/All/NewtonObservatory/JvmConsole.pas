namespace NewtonObservatory;

type
  JvmConsole = static class
  public
    class method Run: Boolean;
    begin
      if java.lang.System.console = nil then exit false;
      var lDevice := org.jline.terminal.TerminalBuilder.builder.system(true).dumb(false).build;
      try
        lDevice.enterRawMode;
        exit Terminal.RunFullScreen(lDevice.writer, -> lDevice.getRows, -> lDevice.getColumns,
                                    -> lDevice.reader.read(100), -> begin Explorer.Navigate(new TerminalExplorer); end);
      finally
        lDevice.close;
      end;
    end;
  end;
end.
