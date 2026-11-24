namespace NewtonObservatory
{
  struct SurveyTile
  {
    public String Name { get; }
    public int Left { get; }
    public int Top { get; }
    public int Width { get; }
    public int Height { get; }
    public double CenterReal { get; }
    public double CenterImaginary { get; }
    public double Zoom { get; }

    public SurveyTile(String aName, int aLeft, int aTop, int aWidth, int aHeight, double aCenterReal = 0, double aCenterImaginary = 0, double aZoom = 1)
    {
      Name = aName;
      Left = aLeft;
      Top = aTop;
      Width = aWidth;
      Height = aHeight;
      CenterReal = aCenterReal;
      CenterImaginary = aCenterImaginary;
      Zoom = aZoom;
    }
  }

  sealed class Exposure
  {
    public String[] Rows { get; }
    public int[] RootCounts { get; }
    public int UnresolvedCount { get; private set; }

    public Exposure(int aRowCount)
    {
      Rows = new String[aRowCount];
      RootCounts = new int[NewtonSolver.RootCount];
    }

    public void Tally(OrbitSample aOrbit)
    {
      var lRootIndex = aOrbit.RootIndex;
      if (lRootIndex < 0)
        UnresolvedCount = UnresolvedCount + 1;
      else
        RootCounts[lRootIndex] = RootCounts[lRootIndex] + 1;
    }
  }

  static class Observatory
  {
    public const int PlateWidth = 77;
    public const int PlateHeight = 25;
    private const double RealPitch = 0.045D;
    private const double ImaginaryPitch = 0.105D;
    private const String EastRamp = "@#%*+=:.";
    private const String NorthRamp = "OXxo/;:, ";
    private const String SouthRamp = "WMmvn~-.";

    private static char SamplePixel(SurveyTile aTile, RootPalette aPalette, Exposure aPlate, int aColumn, int aRow)
    {
      // Unequal pitches compensate for the taller-than-wide console cells.
      var lReal = aTile.CenterReal + (((aColumn - (PlateWidth / 2)) * RealPitch) / aTile.Zoom);
      var lImaginary = aTile.CenterImaginary + ((((PlateHeight / 2) - aRow) * ImaginaryPitch) / aTile.Zoom);
      var lOrbit = NewtonSolver.Classify(lReal, lImaginary);
      aPlate.Tally(lOrbit);
      return aPalette.ShadeFor(lOrbit, aTile.Name, aColumn, aRow);
    }

    private static String RenderRow(SurveyTile aTile, RootPalette aPalette, Exposure aPlate, int aRow)
    {
      var lRow = new StringBuilder();
      for (int lColumn = aTile.Left; lColumn <= (aTile.Left + aTile.Width) - 1; lColumn++ )
        lRow.Append(SamplePixel(aTile, aPalette, aPlate, lColumn, aRow));
      return lRow.ToString();
    }

    private static Exposure RenderTile(SurveyTile aTile, RootPalette aPalette)
    {
      var lExposure = new Exposure(aTile.Height);
      for (int lLocalRow = 0; lLocalRow <= aTile.Height - 1; lLocalRow++ )
        lExposure.Rows[lLocalRow] = RenderRow(aTile, aPalette, lExposure, aTile.Top + lLocalRow);
      return lExposure;
    }

    private static void PrintPlate(Exposure aExposure)
    {
      String lRuleStart = "+";
      var lRule = lRuleStart.PadEnd(PlateWidth + 1, '-') + '+';
      writeLn(lRule);
      writeLn("|  N E W T O N   O B S E R V A T O R Y".PadEnd(PlateWidth + 1) + '|');
      writeLn("|  PLATE 01  /  BASINS OF z^3 - 1  /  77 x 25 SAMPLES".PadEnd(PlateWidth + 1) + '|');
      writeLn(lRule);
      foreach (var lRow in aExposure.Rows)
        writeLn('|' + lRow + '|');
      writeLn(lRule);
      writeLn($"  @ EAST   {aExposure.RootCounts[0]}   O NORTH  {aExposure.RootCounts[1]}   " + $"W SOUTH  {aExposure.RootCounts[2]}   ? UNRESOLVED  {aExposure.UnresolvedCount}");
      writeLn($"  Each ramp runs fast -> slow convergence (limit: {NewtonSolver.StepLimit} steps).");
    }

    private static void DevelopCalibrationTile()
    {
      var lCalibrationPalette = new RootPalette("calibration/3-ramp", new [] {EastRamp, NorthRamp, SouthRamp});
      var lCalibrationTile = new SurveyTile("SOUTH-03", 24, 20, 9, 4);
      RenderTile(lCalibrationTile, lCalibrationPalette);
    }

    private static Exposure RenderWithMasterPalette(SurveyTile aTile)
    {
      var lMasterPalette = new RootPalette("master/3-ramp", new [] {EastRamp, NorthRamp, SouthRamp});
      return RenderTile(aTile, lMasterPalette);
    }

    public static Exposure RenderViewport(int aWidth, int aHeight, double aCenterReal, double aCenterImaginary, double aZoom)
    {
      var lView = new SurveyTile("EXPLORER", (PlateWidth / 2) - (aWidth / 2), (PlateHeight / 2) - (aHeight / 2), aWidth, aHeight, aCenterReal, aCenterImaginary, aZoom);
      return RenderWithMasterPalette(lView);
    }

    public static void Run()
    {
      var lSurvey = new SurveyTile("PLATE-01", 0, 0, PlateWidth, PlateHeight);
      var lPlate = RenderWithMasterPalette(lSurvey);
      PrintPlate(lPlate);
      writeLn("");
      writeLn("  [02 / CALIBRATION] Developing SOUTH-03 with calibration/3-ramp...");
      DevelopCalibrationTile();
    }
  }

}
