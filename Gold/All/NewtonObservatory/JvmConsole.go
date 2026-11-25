package NewtonObservatory

import "org.jline.terminal"
import "java.lang"

func StartSession() Boolean {
    if lang.System.console() == nil {
        return false
    }
    device := terminal.TerminalBuilder.builder().system(true).dumb(false).build()
    defer device.close()
    device.enterRawMode()
    return Terminal.RunFullScreen(device.writer(),
        func() Int32 { return device.getRows() },
        func() Int32 { return device.getColumns() },
        func() Int32 { return device.reader().read(100) }, Navigate)
}
