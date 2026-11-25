namespace NewtonObservatory
{
  class Program
  {
    public static int Main(String[] aArgs)
    {
      foreach (var lArgument in aArgs)
        if (lArgument == "--explore")
          return Explorer.Run();
      Observatory.Run();
      return 0;
    }
  }

}
