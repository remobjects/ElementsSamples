package NewtonObservatory;

class Program
{
  public static int Main(String[] aArgs)
  {
    for (String lArgument: aArgs)
      if (lArgument == "--explore")
        return Explorer.Run();
    Observatory.Run();
    return 0;
  }
}
