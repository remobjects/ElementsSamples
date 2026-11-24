final class RootPalette {
  private var fRamps: String[]

  public let Channel: String

  public var Size: Int32 {
    get {
      return length(fRamps)
    }
  }

  public init(_ aChannel: String, _ aRamps: String[]) {
    Channel = aChannel
    fRamps = aRamps
  }

  public func ShadeFor(_ aOrbit: OrbitSample, _ aTileLabel: String, _ aColumn: Int32, _ aRow: Int32) -> Char {
    var lRootIndex = aOrbit.RootIndex
    if lRootIndex < 0 {
      return "?"
    }
    var lPaletteSize = Size
    if lRootIndex >= lPaletteSize {
      var lReason = "Palette \"\(Channel)\" has \(lPaletteSize) ramps; root index \(lRootIndex) has no ramp. " + "Tile \(aTileLabel), pixel (\(aColumn), \(aRow)), converged in \(aOrbit.Steps) steps."
      throw RemObjects.Elements.RTL.RTLException(lReason)
    }
    var lRamp = fRamps[lRootIndex]
    var lShadeIndex = aOrbit.Steps / 2
    if lShadeIndex >= lRamp.Length {
      lShadeIndex = lRamp.Length - 1
    }
    return lRamp[lShadeIndex]
  }
}
