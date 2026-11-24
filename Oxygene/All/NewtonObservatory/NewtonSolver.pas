namespace NewtonObservatory;

type
  OrbitSample = public record
  public

    property RootIndex: Integer; readonly;
    property Steps: Integer; readonly;
    property FinalReal: Double; readonly;
    property FinalImaginary: Double; readonly;

    constructor(aRootIndex, aSteps: Integer; aFinalReal, aFinalImaginary: Double);
    begin
      RootIndex := aRootIndex;
      Steps := aSteps;
      FinalReal := aFinalReal;
      FinalImaginary := aFinalImaginary;
    end;

  end;

  NewtonSolver = public static class
  private

    const RootHeight = 0.8660254037844386;
    const ToleranceSquared = 1E-12;

    class method NearRoot(aReal, aImaginary, aRootReal, aRootImaginary: Double): Boolean;
    begin
      var lDeltaReal := aReal - aRootReal;
      var lDeltaImaginary := aImaginary - aRootImaginary;
      result := lDeltaReal * lDeltaReal + lDeltaImaginary * lDeltaImaginary ≤ ToleranceSquared;
    end;

  public

    const RootCount = 3;
    const StepLimit = 36;

    class method Classify(aReal, aImaginary: Double): OrbitSample;
    begin
      var lReal := aReal;
      var lImaginary := aImaginary;

      for lStep: Integer := 0 to StepLimit do begin
        if NearRoot(lReal, lImaginary, 1.0, 0.0) then
          exit new OrbitSample(0, lStep, lReal, lImaginary);
        if NearRoot(lReal, lImaginary, -0.5, RootHeight) then
          exit new OrbitSample(1, lStep, lReal, lImaginary);
        if NearRoot(lReal, lImaginary, -0.5, -RootHeight) then
          exit new OrbitSample(2, lStep, lReal, lImaginary);

        var lSquareReal := lReal * lReal - lImaginary * lImaginary;
        var lSquareImaginary := 2.0 * lReal * lImaginary;
        var lNormSquared := lSquareReal * lSquareReal + lSquareImaginary * lSquareImaginary;
        if lStep = StepLimit then
          break;
        if lNormSquared ≤ 1E-24 then
          exit new OrbitSample(-1, lStep, lReal, lImaginary);

        // For z^3 - 1, the Newton update simplifies to (2z + 1/z^2) / 3.
        lReal := (2.0 * lReal + lSquareReal / lNormSquared) / 3.0;
        lImaginary := (2.0 * lImaginary - lSquareImaginary / lNormSquared) / 3.0;
      end;

      result := new OrbitSample(-1, StepLimit, lReal, lImaginary);
    end;

  end;

end.
