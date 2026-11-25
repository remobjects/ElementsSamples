from RemObjects.Elements.RTL import Terminal as RtlTerminal
from org.jline.terminal import TerminalBuilder
from java.lang import System

def start_session() -> bool:
    if System.console() is None:
        return False
    device: org.jline.terminal.Terminal = TerminalBuilder.builder().system(True).dumb(False).build()
    try:
        device.enterRawMode()
        writer: java.io.PrintWriter = device.writer()
        return RtlTerminal.RunFullScreen(writer, lambda: device.getRows(), lambda: device.getColumns(),
                                         lambda: device.reader().read(100), Navigate)
    finally:
        device.close()
