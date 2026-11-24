namespace NewtonObservatory
{
  class Program
  {
    public static int Main(String[] aArgs)
    {
      foreach (var lArgument in aArgs)
        if (lArgument == "--explore")
          return TerminalExplorer.Run();
      Observatory.Run();
      return 0;
    }
  }

}
