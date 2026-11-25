package NewtonObservatory

func nearRoot(x, y, rootX, rootY Double) Boolean {
    dx := x - rootX
    dy := y - rootY
    return dx*dx + dy*dy <= 1e-12
}

// Follow one starting point until it reaches a root or runs out of steps.
func sample(x, y Double, mark func(Int32)) String {
    for step := 0; step <= 36; step++ {
        root := -1
        ramp := ""
        switch {
        case nearRoot(x, y, 1.0, 0.0):
            root, ramp = 0, "@#%*+=:."
        case nearRoot(x, y, -0.5, 0.8660254037844386):
            root, ramp = 1, "OXxo/;:, "
        case nearRoot(x, y, -0.5, -0.8660254037844386):
            root, ramp = 2, "WMmvn~-."
        }
        if root >= 0 {
            shade := step / 2
            if shade >= ramp.Length {
                shade = ramp.Length - 1
            }
            mark(Int32(root))
            return ramp.Substring(shade, 1)
        }
        squareX := x*x - y*y
        squareY := 2.0*x*y
        norm := squareX*squareX + squareY*squareY
        if step == 36 || norm <= 1e-24 {
            break
        }
        x = (2.0*x + squareX/norm) / 3.0
        y = (2.0*y - squareY/norm) / 3.0
    }
    mark(-1)
    return "?"
}

func RenderRegion(width, height, left, top Int32, centerX, centerY, zoom Double, emit func(Int32, String), tally func(Int32, Int32, Int32, Int32)) {
    east, north, south, missing := Int32(0), Int32(0), Int32(0), Int32(0)
    mark := func(root Int32) {
        switch root {
        case 0: east++
        case 1: north++
        case 2: south++
        default: missing++
        }
    }
    for row := Int32(0); row < height; row++ {
        y := centerY - Double(row+top)*0.105/zoom
        line := make(StringBuilder)
        for col := Int32(0); col < width; col++ {
            x := centerX + Double(col+left)*0.045/zoom
            line.Append(sample(x, y, mark))
        }
        emit(row, line.ToString())
    }
    tally(east, north, south, missing)
}

func PrintSurvey() {
    rule := "+".PadEnd(78, '-') + "+"
    writeLn(rule)
    writeLn("|  N E W T O N   O B S E R V A T O R Y".PadEnd(78) + "|")
    writeLn("|  PLATE 01  /  BASINS OF z^3 - 1  /  77 x 25 SAMPLES".PadEnd(78) + "|")
    writeLn(rule)
    RenderRegion(77, 25, -38, -12, 0, 0, 1, func(row Int32, text String) {
        writeLn("|" + text + "|")
    }, func(east, north, south, missing Int32) {
        writeLn(rule)
        writeLn("  @ EAST   " + Convert.ToString(east) + "   O NORTH  " + Convert.ToString(north) +
            "   W SOUTH  " + Convert.ToString(south) + "   ? UNRESOLVED  " + Convert.ToString(missing))
    })
    writeLn("  Each ramp runs fast -> slow convergence (limit: 36 steps).")
    writeLn("")
    writeLn("  [02 / CALIBRATION] Developing SOUTH-03 with calibration/3-ramp...")
    RenderRegion(9, 4, -14, 8, 0, 0, 1, func(row Int32, text String) {}, func(east, north, south, missing Int32) {})
}

func Main(args ...String) Int32 {
    for index := 0; index < length(args); index++ {
        if args[index] == "--explore" {
            return Run()
        }
    }
    PrintSurvey()
    return 0
}
