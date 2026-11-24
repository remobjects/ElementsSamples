public struct OrbitSample {
  public let RootIndex: Int32
  public let Steps: Int32
  public let FinalReal: Double
  public let FinalImaginary: Double

  public init(_ aRootIndex: Int32, _ aSteps: Int32, _ aFinalReal: Double, _ aFinalImaginary: Double) {
    RootIndex = aRootIndex
    Steps = aSteps
    FinalReal = aFinalReal
    FinalImaginary = aFinalImaginary
  }
}

final class NewtonSolver {
  private static let RootHeight: Double = 0.8660254037844386
  private static let ToleranceSquared: Double = 1E-12
  public static let RootCount: Int32 = 3
  public static let StepLimit: Int32 = 36

  private static func NearRoot(_ aReal: Double, _ aImaginary: Double, _ aRootReal: Double, _ aRootImaginary: Double) -> Boolean {
    var lDeltaReal = aReal - aRootReal
    var lDeltaImaginary = aImaginary - aRootImaginary
    return ((lDeltaReal * lDeltaReal) + (lDeltaImaginary * lDeltaImaginary)) <= ToleranceSquared
  }

  public static func Classify(_ aReal: Double, _ aImaginary: Double) -> OrbitSample {
    var lReal = aReal
    var lImaginary = aImaginary
    for lStep in 0 ... StepLimit {
      if NearRoot(lReal, lImaginary, 1.0, 0.0) {
        return OrbitSample(0, lStep, lReal, lImaginary)
      }
      if NearRoot(lReal, lImaginary, -0.5, RootHeight) {
        return OrbitSample(1, lStep, lReal, lImaginary)
      }
      if NearRoot(lReal, lImaginary, -0.5, -RootHeight) {
        return OrbitSample(2, lStep, lReal, lImaginary)
      }
      var lSquareReal = (lReal * lReal) - (lImaginary * lImaginary)
      var lSquareImaginary = 2.0 * lReal * lImaginary
      var lNormSquared = (lSquareReal * lSquareReal) + (lSquareImaginary * lSquareImaginary)
      if lStep == StepLimit {
        break
      }
      if lNormSquared <= 1E-24 {
        return OrbitSample(-1, lStep, lReal, lImaginary)
      }
      // For z^3 - 1, the Newton update simplifies to (2z + 1/z^2) / 3.
      lReal = ((2.0 * lReal) + (lSquareReal / lNormSquared)) / 3.0
      lImaginary = ((2.0 * lImaginary) - (lSquareImaginary / lNormSquared)) / 3.0
    }
    return OrbitSample(-1, StepLimit, lReal, lImaginary)
  }
}
