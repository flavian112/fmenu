import Cocoa

class AppWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }
}
