package NewtonObservatory;

__struct SurveyTile
{
  public String Name { __get; }
  public int Left { __get; }
  public int Top { __get; }
  public int Width { __get; }
  public int Height { __get; }
  public double CenterReal { __get; }
  public double CenterImaginary { __get; }
  public double Zoom { __get; }

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

final class Exposure
{
  public String[] Rows { __get; }
  public int[] RootCounts { __get; }
  public int UnresolvedCount;

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

class Observatory
{
  public static final int PlateWidth = 77;
  public static final int PlateHeight = 25;
  private static final double RealPitch = 0.045D;
  private static final double ImaginaryPitch = 0.105D;
  private static final String EastRamp = "@#%*+=:.";
  private static final String NorthRamp = "OXxo/;:, ";
  private static final String SouthRamp = "WMmvn~-.";

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
    for (String lRow: aExposure.Rows)
      writeLn('|' + lRow + '|');
    writeLn(lRule);
    writeLn("  @ EAST   " + Convert.ToString(aExposure.RootCounts[0]) + "   O NORTH  " + Convert.ToString(aExposure.RootCounts[1])
        + "   W SOUTH  " + Convert.ToString(aExposure.RootCounts[2]) + "   ? UNRESOLVED  " + Convert.ToString(aExposure.UnresolvedCount));
    writeLn("  Each ramp runs fast -> slow convergence (limit: " + Convert.ToString(NewtonSolver.StepLimit) + " steps).");
  }

  private static void DevelopCalibrationTile()
  {
    var lCalibrationPalette = new RootPalette("calibration/3-ramp", new String[] {EastRamp, NorthRamp, SouthRamp});
    var lCalibrationTile = new SurveyTile("SOUTH-03", 24, 20, 9, 4);
    RenderTile(lCalibrationTile, lCalibrationPalette);
  }

  private static Exposure RenderWithMasterPalette(SurveyTile aTile)
  {
    var lMasterPalette = new RootPalette("master/3-ramp", new String[] {EastRamp, NorthRamp, SouthRamp});
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
