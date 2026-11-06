import Foundation
import rtl

class FallingBricks:
    board: String = ""
    bag: String = ""
    shapes: String = "0000111100000000011001100000000001001110000000000110110000000000110001100000000010001110000000000010111000000000"
    piece: Int32 = 0
    nextPiece: Int32 = 0
    rotation: Int32 = 0
    x: Int32 = 3
    y: Int32 = 0
    score: Int32 = 0
    lines: Int32 = 0
    paused: Boolean = False
    over: Boolean = False
    lastFall: Double = 0.0
    message: String = ""

    def number(self, value: Int32) -> String:
        return NSString.stringWithFormat("%d", value)

    def reset(self):
        self.board = ""
        i: Int32 = 0
        while i < 200:
            self.board += "0"
            i += 1
        self.bag = ""
        self.score = 0
        self.lines = 0
        self.paused = False
        self.over = False
        self.message = "Let's stack!"
        self.nextPiece = self.drawPiece()
        self.spawn()

    def drawPiece(self) -> Int32:
        if self.bag.length == 0:
            self.bag = "0123456"
        index: Int32 = arc4random_uniform(self.bag.length)
        piece: Int32 = self.bag.characterAtIndex(index) - 48
        self.bag = self.bag.substringToIndex(index) + self.bag.substringFromIndex(index + 1)
        return piece

    def spawn(self):
        self.piece = self.nextPiece
        self.nextPiece = self.drawPiece()
        self.rotation = 0
        self.x = 3
        self.y = 0
        self.lastFall = NSDate.timeIntervalSinceReferenceDate
        if not self.fits(self.x, self.y, self.rotation):
            self.over = True
            self.message = "GAME OVER! R: play again   Q: quit"

    def occupied(self, piece: Int32, rotation: Int32, x: Int32, y: Int32) -> Boolean:
        if piece == 1:
            rotation = 0
        i: Int32 = 0
        while i < rotation:
            oldX: Int32 = x
            x = y
            y = 3 - oldX
            i += 1
        return self.shapes.characterAtIndex(piece * 16 + y * 4 + x) == 49

    def fits(self, px: Int32, py: Int32, rotation: Int32) -> Boolean:
        y: Int32 = 0
        while y < 4:
            x: Int32 = 0
            while x < 4:
                if self.occupied(self.piece, rotation, x, y):
                    bx: Int32 = px + x
                    by: Int32 = py + y
                    if bx < 0 or bx >= 10 or by < 0 or by >= 20:
                        return False
                    if self.board.characterAtIndex(by * 10 + bx) != 48:
                        return False
                x += 1
            y += 1
        return True

    def setCell(self, index: Int32, value: Int32):
        self.board = self.board.substringToIndex(index) + self.number(value) + self.board.substringFromIndex(index + 1)

    def move(self, dx: Int32):
        if self.fits(self.x + dx, self.y, self.rotation):
            self.x += dx

    def rotate(self):
        rotation: Int32 = (self.rotation + 1) % 4
        attempt: Int32 = 0
        while attempt < 5:
            offset: Int32 = 0
            if attempt == 1:
                offset = -1
            elif attempt == 2:
                offset = 1
            elif attempt == 3:
                offset = -2
            elif attempt == 4:
                offset = 2
            if self.fits(self.x + offset, self.y, rotation):
                self.x += offset
                self.rotation = rotation
                return
            attempt += 1

    def lock(self):
        y: Int32 = 0
        while y < 4:
            x: Int32 = 0
            while x < 4:
                if self.occupied(self.piece, self.rotation, x, y):
                    self.setCell((self.y + y) * 10 + self.x + x, self.piece + 1)
                x += 1
            y += 1
        # Copy surviving rows bottom-up so adjacent full rows are never skipped.
        destination: Int32 = 19
        source: Int32 = 19
        cleared: Int32 = 0
        while source >= 0:
            full: Boolean = True
            x: Int32 = 0
            while x < 10:
                if self.board.characterAtIndex(source * 10 + x) == 48:
                    full = False
                x += 1
            if full:
                cleared += 1
            else:
                x = 0
                while x < 10:
                    value: Int32 = self.board.characterAtIndex(source * 10 + x) - 48
                    self.setCell(destination * 10 + x, value)
                    x += 1
                destination -= 1
            source -= 1
        while destination >= 0:
            x: Int32 = 0
            while x < 10:
                self.setCell(destination * 10 + x, 0)
                x += 1
            destination -= 1
        if cleared > 0:
            points: Int32 = cleared * cleared
            self.score += points
            self.lines += cleared
            self.message = self.number(cleared) + " lines! +" + self.number(points) + " points"
            if cleared == 4:
                self.message = "FOUR-LINE FIESTA! +16 points"
        else:
            self.message = "Keep it tidy!"
        self.spawn()

    def step(self):
        if self.fits(self.x, self.y + 1, self.rotation):
            self.y += 1
        else:
            self.lock()

    def drop(self):
        while self.fits(self.x, self.y + 1, self.rotation):
            self.y += 1
        self.lock()

    def key(self, key: Int32) -> Boolean:
        if key == 113 or key == 81 or key == 3:
            return False
        if key == 114 or key == 82:
            self.reset()
        elif key == 112 or key == 80:
            if not self.over:
                self.paused = not self.paused
                self.lastFall = NSDate.timeIntervalSinceReferenceDate
        elif not self.paused and not self.over:
            if key == 68 or key == 97:
                self.move(-1)
            elif key == 67 or key == 100:
                self.move(1)
            elif key == 65 or key == 119 or key == 120:
                self.rotate()
            elif key == 66 or key == 115 or key == 32:
                self.drop()
        return True

    def color(self, value: Int32) -> String:
        return "\x1b[" + self.number(90 + value) + "m[]\x1b[0m"

    def render(self):
        ghostY: Int32 = self.y
        if not self.over:
            while self.fits(self.x, ghostY + 1, self.rotation):
                ghostY += 1
        frame: String = "\x1b[H\x1b[1;96m  F A L L I N G   B R I C K S\x1b[0m\x1b[K\r\n"
        frame += "  +--------------------+\x1b[K\r\n"
        y: Int32 = 0
        while y < 20:
            frame += "  |"
            x: Int32 = 0
            while x < 10:
                value: Int32 = self.board.characterAtIndex(y * 10 + x) - 48
                active: Boolean = False
                ghost: Boolean = False
                localX: Int32 = x - self.x
                if not self.over and localX >= 0 and localX < 4:
                    localY: Int32 = y - self.y
                    if localY >= 0 and localY < 4:
                        active = self.occupied(self.piece, self.rotation, localX, localY)
                    localY = y - ghostY
                    if localY >= 0 and localY < 4:
                        ghost = self.occupied(self.piece, self.rotation, localX, localY)
                if active:
                    value = self.piece + 1
                if value != 0:
                    frame += self.color(value)
                elif ghost:
                    frame += "\x1b[90m::\x1b[0m"
                else:
                    frame += "  "
                x += 1
            frame += "|"
            if y == 0:
                frame += "   Score: " + self.number(self.score)
            elif y == 2:
                frame += "   Lines: " + self.number(self.lines)
            elif y == 4:
                frame += "   Level: " + self.number(1 + self.lines // 10)
            elif y == 6:
                frame += "   Next:"
            elif y >= 7 and y <= 10:
                frame += "   "
                nx: Int32 = 0
                while nx < 4:
                    if self.occupied(self.nextPiece, 0, nx, y - 7):
                        frame += self.color(self.nextPiece + 1)
                    else:
                        frame += "  "
                    nx += 1
            elif y == 12:
                frame += "   Left/Right: move"
            elif y == 13:
                frame += "   Up: rotate"
            elif y == 14:
                frame += "   Down/Space: drop"
            elif y == 16:
                frame += "   P: pause  R: restart"
            elif y == 17:
                frame += "   Q / Ctrl+C: quit"
            elif y == 19:
                frame += "   WASD also works"
            frame += "\x1b[K\r\n"
            y += 1
        frame += "  +--------------------+\x1b[K\r\n"
        if self.paused:
            frame += "  PAUSED - P to resume"
        else:
            frame += "  " + self.message
        frame += "\x1b[K\r\n  Line-clear score: 1 / 4 / 9 / 16\x1b[K\r\n"
        printf("%s", frame.UTF8String)
        fflush(stdout)

    def run(self):
        if isatty(0) == 0 or isatty(1) == 0:
            writeLn("Please run this app in Terminal for live arrow-key input.")
            return
        # Darwin's 64-bit terminal ABI (sys/termios.h and sys/ttycom.h).
        # The imported SDK omits termios wrappers, so use native ioctl directly.
        # Four UInt64 flags, 20 control bytes, alignment, and two UInt64 speeds.
        terminalSettingsSize: Int32 = 72
        getTerminalSettings: UInt64 = 0x40487413  # TIOCGETA
        setTerminalSettings: UInt64 = 0x80487414  # TIOCSETA
        savedMode: NSMutableData = NSMutableData.dataWithLength(terminalSettingsSize)
        if ioctl(0, getTerminalSettings, savedMode.mutableBytes) != 0:
            writeLn("Unable to save the terminal settings.")
            return
        savedFlags: Int32 = fcntl(0, F_GETFL, 0)
        if savedFlags == -1:
            writeLn("Unable to save the input descriptor flags.")
            return
        inputMode: NSMutableData = NSMutableData.dataWithData(savedMode)
        # Disable input/output processing, canonical input, echo and signals.
        # Preserve hardware flags, speeds, and all other control characters.
        inputMode.resetBytesInRange(NSMakeRange(0, 16))
        inputMode.resetBytesInRange(NSMakeRange(24, 8))
        # c_cc[VMIN] and c_cc[VTIME]: reads return immediately when no key is ready.
        inputMode.resetBytesInRange(NSMakeRange(48, 2))
        screenActive: Boolean = False
        try:
            if ioctl(0, setTerminalSettings, inputMode.mutableBytes) != 0:
                writeLn("Unable to enable live keyboard input.")
                return
            if fcntl(0, F_SETFL, savedFlags | O_NONBLOCK) == -1:
                writeLn("Unable to enable keyboard polling.")
                return
            screenActive = True
            printf("\x1b[?1049h\x1b[?25l\x1b[2J\x1b[H")
            fflush(stdout)
            running: Boolean = True
            escape: Int32 = 0
            escapeTime: Double = 0.0
            while running:
                now: Double = NSDate.timeIntervalSinceReferenceDate
                if escape != 0 and now - escapeTime > 0.2:
                    escape = 0
                clearerr(stdin)
                code: Int32 = getchar()
                while code != -1 and running:
                    if code == 3:
                        running = False
                    elif code == 27:
                        escape = 1
                        escapeTime = now
                    elif escape == 1:
                        if code == 91 or code == 79:
                            escape = 2
                        else:
                            escape = 0
                    elif escape == 2:
                        if code >= 65 and code <= 68:
                            running = self.key(code)
                        escape = 0
                    else:
                        running = self.key(code)
                    if running:
                        code = getchar()
                if running:
                    interval: Double = 0.7 - (self.lines // 10) * 0.055
                    if interval < 0.09:
                        interval = 0.09
                    if not self.paused and not self.over and now - self.lastFall >= interval:
                        self.step()
                        self.lastFall = now
                    self.render()
                    NSThread.sleepForTimeInterval(0.016)
        finally:
            if fcntl(0, F_SETFL, savedFlags) == -1:
                writeLn("Unable to restore the input descriptor flags.")
            if ioctl(0, setTerminalSettings, savedMode.mutableBytes) != 0:
                writeLn("Unable to restore the terminal settings.")
            if screenActive:
                printf("\x1b[0m\x1b[?25h\x1b[?1049l")
                fflush(stdout)
        writeLn("Thanks for playing! Final score: " + self.number(self.score))


game: FallingBricks = FallingBricks()
game.reset()
game.run()
