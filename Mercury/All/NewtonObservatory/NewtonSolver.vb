Namespace Global.NewtonObservatory

  Public Structure OrbitSample

    Public ReadOnly Property RootIndex As Integer
    Public ReadOnly Property Steps As Integer
    Public ReadOnly Property FinalReal As Double
    Public ReadOnly Property FinalImaginary As Double

    Public Sub New(aRootIndex As Integer, aSteps As Integer, aFinalReal As Double, aFinalImaginary As Double)
      RootIndex = aRootIndex
      Steps = aSteps
      FinalReal = aFinalReal
      FinalImaginary = aFinalImaginary
    End Sub

  End Structure

  Public Module NewtonSolver

    Private Const RootHeight As Double = 0.8660254037844386
    Private Const ToleranceSquared As Double = 1E-12
    Public Const RootCount As Integer = 3
    Public Const StepLimit As Integer = 36

    Private Function NearRoot(aReal As Double, aImaginary As Double, aRootReal As Double, aRootImaginary As Double) As Boolean
      Dim lDeltaReal = aReal - aRootReal
      Dim lDeltaImaginary = aImaginary - aRootImaginary
      Return ((lDeltaReal * lDeltaReal) + (lDeltaImaginary * lDeltaImaginary)) <= ToleranceSquared
    End Function

    Public Function Classify(aReal As Double, aImaginary As Double) As OrbitSample
      Dim lReal = aReal
      Dim lImaginary = aImaginary
      For lStep As Integer = 0 To StepLimit
        If NearRoot(lReal, lImaginary, 1.0, 0.0) Then
          Return New OrbitSample(0, lStep, lReal, lImaginary)
        End If
        If NearRoot(lReal, lImaginary, -0.5, RootHeight) Then
          Return New OrbitSample(1, lStep, lReal, lImaginary)
        End If
        If NearRoot(lReal, lImaginary, -0.5, -RootHeight) Then
          Return New OrbitSample(2, lStep, lReal, lImaginary)
        End If
        Dim lSquareReal = (lReal * lReal) - (lImaginary * lImaginary)
        Dim lSquareImaginary = 2.0 * lReal * lImaginary
        Dim lNormSquared = (lSquareReal * lSquareReal) + (lSquareImaginary * lSquareImaginary)
        If lStep = StepLimit Then
          Exit For
        End If
        If lNormSquared <= 1E-24 Then
          Return New OrbitSample(-1, lStep, lReal, lImaginary)
        End If
        '  For z^3 - 1, the Newton update simplifies to (2z + 1/z^2) / 3.
        lReal = ((2.0 * lReal) + (lSquareReal / lNormSquared)) / 3.0
        lImaginary = ((2.0 * lImaginary) - (lSquareImaginary / lNormSquared)) / 3.0
      Next
      Return New OrbitSample(-1, StepLimit, lReal, lImaginary)
    End Function

  End Module

End Namespace
