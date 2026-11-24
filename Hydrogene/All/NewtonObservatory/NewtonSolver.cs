namespace NewtonObservatory
{
  public struct OrbitSample
  {
    public int RootIndex { get; }
    public int Steps { get; }
    public double FinalReal { get; }
    public double FinalImaginary { get; }

    public OrbitSample(int aRootIndex, int aSteps, double aFinalReal, double aFinalImaginary)
    {
      RootIndex = aRootIndex;
      Steps = aSteps;
      FinalReal = aFinalReal;
      FinalImaginary = aFinalImaginary;
    }
  }

  public static class NewtonSolver
  {
    private const double RootHeight = 0.8660254037844386D;
    private const double ToleranceSquared = 1E-12D;
    public const int RootCount = 3;
    public const int StepLimit = 36;

    private static bool NearRoot(double aReal, double aImaginary, double aRootReal, double aRootImaginary)
    {
      var lDeltaReal = aReal - aRootReal;
      var lDeltaImaginary = aImaginary - aRootImaginary;
      return ((lDeltaReal * lDeltaReal) + (lDeltaImaginary * lDeltaImaginary)) <= ToleranceSquared;
    }

    public static OrbitSample Classify(double aReal, double aImaginary)
    {
      var lReal = aReal;
      var lImaginary = aImaginary;
      for (int lStep = 0; lStep <= StepLimit; lStep++ )
      {
        if (NearRoot(lReal, lImaginary, 1.0D, 0.0D))
          return new OrbitSample(0, lStep, lReal, lImaginary);
        if (NearRoot(lReal, lImaginary, -0.5D, RootHeight))
          return new OrbitSample(1, lStep, lReal, lImaginary);
        if (NearRoot(lReal, lImaginary, -0.5D, -RootHeight))
          return new OrbitSample(2, lStep, lReal, lImaginary);
        var lSquareReal = (lReal * lReal) - (lImaginary * lImaginary);
        var lSquareImaginary = 2.0D * lReal * lImaginary;
        var lNormSquared = (lSquareReal * lSquareReal) + (lSquareImaginary * lSquareImaginary);
        if (lStep == StepLimit)
          break;
        if (lNormSquared <= 1E-24D)
          return new OrbitSample(-1, lStep, lReal, lImaginary);
        // For z^3 - 1, the Newton update simplifies to (2z + 1/z^2) / 3.
        lReal = ((2.0D * lReal) + (lSquareReal / lNormSquared)) / 3.0D;
        lImaginary = ((2.0D * lImaginary) - (lSquareImaginary / lNormSquared)) / 3.0D;
      }
      return new OrbitSample(-1, StepLimit, lReal, lImaginary);
    }
  }

}
