namespace NewtonObservatory;

type
  Program = class
  public

    class method Main(aArgs: array of String): Int32;
    begin
      for each lArgument in aArgs do
        if lArgument = '--explore' then
          exit TerminalExplorer.Run;

      Observatory.Run;
      result := 0;
    end;

  end;

end.
