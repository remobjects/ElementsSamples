package NewtonObservatory;

public __struct OrbitSample
{
  public int RootIndex { __get; }
  public int Steps { __get; }
  public double FinalReal { __get; }
  public double FinalImaginary { __get; }

  public OrbitSample(int aRootIndex, int aSteps, double aFinalReal, double aFinalImaginary)
  {
    RootIndex = aRootIndex;
    Steps = aSteps;
    FinalReal = aFinalReal;
    FinalImaginary = aFinalImaginary;
  }
}

public class NewtonSolver
{
  private static final double RootHeight = 0.8660254037844386D;
  private static final double ToleranceSquared = 1E-12D;
  public static final int RootCount = 3;
  public static final int StepLimit = 36;

  private static boolean NearRoot(double aReal, double aImaginary, double aRootReal, double aRootImaginary)
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
