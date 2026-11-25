class Exposure:
    Rows: RemObjects.Elements.RTL.List[str]
    RootCounts: RemObjects.Elements.RTL.List[int]
    UnresolvedCount: int

    def __init__(self):
        self.Rows = RemObjects.Elements.RTL.List[str]()
        self.RootCounts = RemObjects.Elements.RTL.List[int]()
        for index in range(3):
            self.RootCounts.Add(0)
        self.UnresolvedCount = 0

    def Mark(self, root: int):
        if root < 0:
            self.UnresolvedCount += 1
        else:
            self.RootCounts[root] = self.RootCounts[root] + 1


# Each character identifies the root and how quickly the point reached it.
def near_root(x: float, y: float, root_x: float, root_y: float) -> bool:
    dx: float = x - root_x
    dy: float = y - root_y
    return dx * dx + dy * dy <= 1e-12


def sample(plate: Exposure, x: float, y: float) -> str:
    for step in range(37):
        root: int = -1
        ramp: str = ""
        if near_root(x, y, 1.0, 0.0):
            root = 0
            ramp = "@#%*+=:."
        elif near_root(x, y, -0.5, 0.8660254037844386):
            root = 1
            ramp = "OXxo/;:, "
        elif near_root(x, y, -0.5, -0.8660254037844386):
            root = 2
            ramp = "WMmvn~-."
        if root >= 0:
            plate.Mark(root)
            shade: int = step // 2
            if shade >= len(ramp):
                shade = len(ramp) - 1
            return ramp[shade]
        square_x: float = x * x - y * y
        square_y: float = 2.0 * x * y
        norm: float = square_x * square_x + square_y * square_y
        if step == 36 or norm <= 1e-24:
            break
        # Newton's update for z cubed minus one is (2z + 1/z²) / 3.
        x = (2.0 * x + square_x / norm) / 3.0
        y = (2.0 * y - square_y / norm) / 3.0
    plate.Mark(-1)
    return "?"


def RenderRegion(width: int, height: int, left: int, top: int, center_x: float, center_y: float, zoom: float) -> Exposure:
    plate: Exposure = Exposure()
    for row in range(height):
        y: float = center_y - (row + top) * 0.105 / zoom
        line: StringBuilder = StringBuilder()
        for column in range(width):
            x: float = center_x + (column + left) * 0.045 / zoom
            line.Append(sample(plate, x, y))
        plate.Rows.Add(line.ToString())
    return plate


def PrintSurvey():
    plate: Exposure = RenderRegion(77, 25, -38, -12, 0.0, 0.0, 1.0)
    print("+" + "-" * 77 + "+")
    print("|  N E W T O N   O B S E R V A T O R Y".PadEnd(78) + "|")
    print("|  PLATE 01  /  BASINS OF z^3 - 1  /  77 x 25 SAMPLES".PadEnd(78) + "|")
    print("+" + "-" * 77 + "+")
    for row in plate.Rows:
        print("|" + row + "|")
    print("+" + "-" * 77 + "+")
    print("  @ EAST   {0}   O NORTH  {1}   W SOUTH  {2}   ? UNRESOLVED  {3}".format(plate.RootCounts[0], plate.RootCounts[1], plate.RootCounts[2], plate.UnresolvedCount))
    print("  Each ramp runs fast -> slow convergence (limit: 36 steps).")
    print("")
    print("  [02 / CALIBRATION] Developing SOUTH-03 with calibration/3-ramp...")
    RenderRegion(9, 4, -14, 8, 0.0, 0.0, 1.0)


class Program:
    @staticmethod
    def Main(args: str[]) -> int:
        for argument in args:
            if argument == "--explore":
                return Run()
        PrintSurvey()
        return 0
