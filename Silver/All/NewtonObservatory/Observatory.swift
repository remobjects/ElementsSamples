struct SurveyTile {
  public let Name: String
  public let Left: Int32
  public let Top: Int32
  public let Width: Int32
  public let Height: Int32
  public let CenterReal: Double
  public let CenterImaginary: Double
  public let Zoom: Double

  public init(_ aName: String, _ aLeft: Int32, _ aTop: Int32, _ aWidth: Int32, _ aHeight: Int32, _ aCenterReal: Double = 0, _ aCenterImaginary: Double = 0, _ aZoom: Double = 1) {
    Name = aName
    Left = aLeft
    Top = aTop
    Width = aWidth
    Height = aHeight
    CenterReal = aCenterReal
    CenterImaginary = aCenterImaginary
    Zoom = aZoom
  }
}

final class Exposure {
  public var Rows: String[]
  public var RootCounts: Int32[]
  public var UnresolvedCount: Int32 = 0

  public init(_ aRowCount: Int32) {
    Rows = String[](aRowCount)
    RootCounts = Int32[](NewtonSolver.RootCount)
  }

  public func Tally(_ aOrbit: OrbitSample) {
    var lRootIndex = aOrbit.RootIndex
    if lRootIndex < 0 {
      UnresolvedCount = UnresolvedCount + 1
    } else {
      RootCounts[lRootIndex] = RootCounts[lRootIndex] + 1
    }
  }
}

final class Observatory {
  public static let PlateWidth: Int32 = 77
  public static let PlateHeight: Int32 = 25
  private static let RealPitch: Double = 0.045
  private static let ImaginaryPitch: Double = 0.105
  private static let EastRamp: String = "@#%*+=:."
  private static let NorthRamp: String = "OXxo/;:, "
  private static let SouthRamp: String = "WMmvn~-."

  private static func SamplePixel(_ aTile: SurveyTile, _ aPalette: RootPalette, _ aPlate: Exposure, _ aColumn: Int32, _ aRow: Int32) -> Char {
    // Unequal pitches compensate for the taller-than-wide console cells.
    var lReal = aTile.CenterReal + (((aColumn - (PlateWidth / 2)) * RealPitch) / aTile.Zoom)
    var lImaginary = aTile.CenterImaginary + ((((PlateHeight / 2) - aRow) * ImaginaryPitch) / aTile.Zoom)
    var lOrbit = NewtonSolver.Classify(lReal, lImaginary)
    aPlate.Tally(lOrbit)
    return aPalette.ShadeFor(lOrbit, aTile.Name, aColumn, aRow)
  }

  private static func RenderRow(_ aTile: SurveyTile, _ aPalette: RootPalette, _ aPlate: Exposure, _ aRow: Int32) -> String {
    var lRow = StringBuilder()
    for lColumn in aTile.Left ... (aTile.Left + aTile.Width) - 1 {
      lRow.Append(SamplePixel(aTile, aPalette, aPlate, lColumn, aRow))
    }
    return lRow.ToString()
  }

  private static func RenderTile(_ aTile: SurveyTile, _ aPalette: RootPalette) -> Exposure {
    var lExposure = Exposure(aTile.Height)
    for lLocalRow in 0 ... aTile.Height - 1 {
      lExposure.Rows[lLocalRow] = RenderRow(aTile, aPalette, lExposure, aTile.Top + lLocalRow)
    }
    return lExposure
  }

  private static func PrintPlate(_ aExposure: Exposure) {
    var lRuleStart: String = "+"
    var lRule = lRuleStart.PadEnd(PlateWidth + 1, "-") + "+"
    writeLn(lRule)
    writeLn("|  N E W T O N   O B S E R V A T O R Y".PadEnd(PlateWidth + 1) + "|")
    writeLn("|  PLATE 01  /  BASINS OF z^3 - 1  /  77 x 25 SAMPLES".PadEnd(PlateWidth + 1) + "|")
    writeLn(lRule)
    for lRow in aExposure.Rows {
      writeLn("|" + lRow + "|")
    }
    writeLn(lRule)
    writeLn("  @ EAST   \(aExposure.RootCounts[0])   O NORTH  \(aExposure.RootCounts[1])   " + "W SOUTH  \(aExposure.RootCounts[2])   ? UNRESOLVED  \(aExposure.UnresolvedCount)")
    writeLn("  Each ramp runs fast -> slow convergence (limit: \(NewtonSolver.StepLimit) steps).")
  }

  private static func DevelopCalibrationTile() {
    var lCalibrationPalette = RootPalette("calibration/3-ramp", [EastRamp, NorthRamp, SouthRamp])
    var lCalibrationTile = SurveyTile("SOUTH-03", 24, 20, 9, 4)
    _ = RenderTile(lCalibrationTile, lCalibrationPalette)
  }

  private static func RenderWithMasterPalette(_ aTile: SurveyTile) -> Exposure {
    var lMasterPalette = RootPalette("master/3-ramp", [EastRamp, NorthRamp, SouthRamp])
    return RenderTile(aTile, lMasterPalette)
  }

  public static func RenderViewport(_ aWidth: Int32, _ aHeight: Int32, _ aCenterReal: Double, _ aCenterImaginary: Double, _ aZoom: Double) -> Exposure {
    var lView = SurveyTile("EXPLORER", (PlateWidth / 2) - (aWidth / 2), (PlateHeight / 2) - (aHeight / 2), aWidth, aHeight, aCenterReal, aCenterImaginary, aZoom)
    return RenderWithMasterPalette(lView)
  }

  public static func Run() {
    var lSurvey = SurveyTile("PLATE-01", 0, 0, PlateWidth, PlateHeight)
    var lPlate = RenderWithMasterPalette(lSurvey)
    PrintPlate(lPlate)
    writeLn("")
    writeLn("  [02 / CALIBRATION] Developing SOUTH-03 with calibration/3-ramp...")
    DevelopCalibrationTile()
  }
}
