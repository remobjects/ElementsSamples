Namespace Global.NewtonObservatory

  Structure SurveyTile

    Public ReadOnly Property Name As String
    Public ReadOnly Property Left As Integer
    Public ReadOnly Property Top As Integer
    Public ReadOnly Property Width As Integer
    Public ReadOnly Property Height As Integer
    Public ReadOnly Property CenterReal As Double
    Public ReadOnly Property CenterImaginary As Double
    Public ReadOnly Property Zoom As Double

    Public Sub New(aName As String, aLeft As Integer, aTop As Integer, aWidth As Integer, aHeight As Integer, Optional aCenterReal As Double = 0, Optional aCenterImaginary As Double = 0, Optional aZoom As Double = 1)
      Name = aName
      Left = aLeft
      Top = aTop
      Width = aWidth
      Height = aHeight
      CenterReal = aCenterReal
      CenterImaginary = aCenterImaginary
      Zoom = aZoom
    End Sub

  End Structure

  NotInheritable Class Exposure

    Public ReadOnly Property Rows As String()
    Public ReadOnly Property RootCounts As Integer()
    Public Property UnresolvedCount As Integer

    Public Sub New(aRowCount As Integer)
      Rows = New String(aRowCount - 1) {}
      RootCounts = New Integer(NewtonSolver.RootCount - 1) {}
    End Sub

    Public Sub Tally(aOrbit As OrbitSample)
      Dim lRootIndex = aOrbit.RootIndex
      If lRootIndex < 0 Then
        UnresolvedCount = UnresolvedCount + 1
      Else
        RootCounts(lRootIndex) = RootCounts(lRootIndex) + 1
      End If
    End Sub

  End Class

  Module Observatory

    Public Const PlateWidth As Integer = 77
    Public Const PlateHeight As Integer = 25
    Private Const RealPitch As Double = 0.045
    Private Const ImaginaryPitch As Double = 0.105
    Private Const EastRamp As String = "@#%*+=:."
    Private Const NorthRamp As String = "OXxo/;:, "
    Private Const SouthRamp As String = "WMmvn~-."

    Private Function SamplePixel(aTile As SurveyTile, aPalette As RootPalette, aPlate As Exposure, aColumn As Integer, aRow As Integer) As Char
      '  Unequal pitches compensate for the taller-than-wide console cells.
      Dim lReal = aTile.CenterReal + (((aColumn - (PlateWidth \ 2)) * RealPitch) / aTile.Zoom)
      Dim lImaginary = aTile.CenterImaginary + ((((PlateHeight \ 2) - aRow) * ImaginaryPitch) / aTile.Zoom)
      Dim lOrbit = NewtonSolver.Classify(lReal, lImaginary)
      aPlate.Tally(lOrbit)
      Return aPalette.ShadeFor(lOrbit, aTile.Name, aColumn, aRow)
    End Function

    Private Function RenderRow(aTile As SurveyTile, aPalette As RootPalette, aPlate As Exposure, aRow As Integer) As String
      Dim lRow = New StringBuilder()
      For lColumn As Integer = aTile.Left To (aTile.Left + aTile.Width) - 1
        lRow.Append(SamplePixel(aTile, aPalette, aPlate, lColumn, aRow))
      Next
      Return lRow.ToString()
    End Function

    Private Function RenderTile(aTile As SurveyTile, aPalette As RootPalette) As Exposure
      Dim lExposure = New Exposure(aTile.Height)
      For lLocalRow As Integer = 0 To aTile.Height - 1
        lExposure.Rows(lLocalRow) = RenderRow(aTile, aPalette, lExposure, aTile.Top + lLocalRow)
      Next
      Return lExposure
    End Function

    Private Sub PrintPlate(aExposure As Exposure)
      Dim lRuleStart As String = "+"c
      Dim lRule = lRuleStart.PadEnd(PlateWidth + 1, "-"c) + "+"c
      writeLn(lRule)
      writeLn("|  N E W T O N   O B S E R V A T O R Y".PadEnd(PlateWidth + 1) + "|"c)
      writeLn("|  PLATE 01  /  BASINS OF z^3 - 1  /  77 x 25 SAMPLES".PadEnd(PlateWidth + 1) + "|"c)
      writeLn(lRule)
      For Each lRow In aExposure.Rows
        writeLn("|"c + lRow + "|"c)
      Next
      writeLn(lRule)
      writeLn($"  @ EAST   {aExposure.RootCounts(0)}   O NORTH  {aExposure.RootCounts(1)}   " + $"W SOUTH  {aExposure.RootCounts(2)}   ? UNRESOLVED  {aExposure.UnresolvedCount}")
      writeLn($"  Each ramp runs fast -> slow convergence (limit: {NewtonSolver.StepLimit} steps).")
    End Sub

    Private Sub DevelopCalibrationTile()
      Dim lCalibrationPalette = New RootPalette("calibration/3-ramp", {EastRamp, NorthRamp, SouthRamp})
      Dim lCalibrationTile = New SurveyTile("SOUTH-03", 24, 20, 9, 4)
      RenderTile(lCalibrationTile, lCalibrationPalette)
    End Sub

    Private Function RenderWithMasterPalette(aTile As SurveyTile) As Exposure
      Dim lMasterPalette = New RootPalette("master/3-ramp", {EastRamp, NorthRamp, SouthRamp})
      Return RenderTile(aTile, lMasterPalette)
    End Function

    Public Function RenderViewport(aWidth As Integer, aHeight As Integer, aCenterReal As Double, aCenterImaginary As Double, aZoom As Double) As Exposure
      Dim lView = New SurveyTile("EXPLORER", (PlateWidth \ 2) - (aWidth \ 2), (PlateHeight \ 2) - (aHeight \ 2), aWidth, aHeight, aCenterReal, aCenterImaginary, aZoom)
      Return RenderWithMasterPalette(lView)
    End Function

    Public Sub Run()
      Dim lSurvey = New SurveyTile("PLATE-01", 0, 0, PlateWidth, PlateHeight)
      Dim lPlate = RenderWithMasterPalette(lSurvey)
      PrintPlate(lPlate)
      writeLn("")
      writeLn("  [02 / CALIBRATION] Developing SOUTH-03 with calibration/3-ramp...")
      DevelopCalibrationTile
    End Sub

  End Module

End Namespace
