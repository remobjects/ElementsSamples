package NewtonObservatory

func nearRoot(x, y, rootX, rootY Double) Boolean {
    dx := x - rootX
    dy := y - rootY
    return dx*dx + dy*dy <= 1e-12
}

// Follow one starting point until it reaches a root or runs out of steps.
func sample(plate Exposure, x, y Double) String {
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
            plate.Mark(Int32(root))
            shade := step / 2
            if shade >= ramp.Length {
                shade = ramp.Length - 1
            }
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
    plate.Mark(-1)
    return "?"
}

func RenderRegion(width, height, left, top Int32, centerX, centerY, zoom Double) Exposure {
    plate := make(Exposure, height)
    for row := Int32(0); row < height; row++ {
        y := centerY - Double(row+top)*0.105/zoom
        line := make(StringBuilder)
        for col := Int32(0); col < width; col++ {
            x := centerX + Double(col+left)*0.045/zoom
            line.Append(sample(plate, x, y))
        }
        plate.Rows[row] = line.ToString()
    }
    return plate
}

func PrintSurvey() {
    plate := RenderRegion(77, 25, -38, -12, 0, 0, 1)
    rule := "+".PadEnd(78, '-') + "+"
    writeLn(rule)
    writeLn("|  N E W T O N   O B S E R V A T O R Y".PadEnd(78) + "|")
    writeLn("|  PLATE 01  /  BASINS OF z^3 - 1  /  77 x 25 SAMPLES".PadEnd(78) + "|")
    writeLn(rule)
    for row := 0; row < 25; row++ {
        writeLn("|" + plate.Rows[row] + "|")
    }
    writeLn(rule)
    writeLn("  @ EAST   " + Convert.ToString(plate.RootCounts[0]) + "   O NORTH  " + Convert.ToString(plate.RootCounts[1]) +
        "   W SOUTH  " + Convert.ToString(plate.RootCounts[2]) + "   ? UNRESOLVED  " + Convert.ToString(plate.UnresolvedCount))
    writeLn("  Each ramp runs fast -> slow convergence (limit: 36 steps).")
    writeLn("")
    writeLn("  [02 / CALIBRATION] Developing SOUTH-03 with calibration/3-ramp...")
    RenderRegion(9, 4, -14, 8, 0, 0, 1)
}
