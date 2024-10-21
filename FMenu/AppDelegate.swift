import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: AppWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        disableSystemLibraryLogs()
        
        let list = readListFromStandardInput()
        
        
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let windowHeight: CGFloat = 50
            
            // Calculate the window frame
            let windowFrame = NSRect(
                x: screenFrame.origin.x,
                y: screenFrame.origin.y + screenFrame.height - 30,
                width: screenFrame.width,
                height: windowHeight
            )
            
            let contentView = FMenuView(searchList: list)
            window = AppWindow(
                contentRect: windowFrame,
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            window.isReleasedWhenClosed = false
            window.level = .screenSaver
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            window.isOpaque = false
            window.backgroundColor = .clear
            window.hasShadow = false
            window.ignoresMouseEvents = false
            window.isMovableByWindowBackground = false
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            
            window.contentView = NSHostingView(rootView: contentView)
            
            showWindow()
        }
    }
    
    func showWindow() {
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func readListFromStandardInput() -> [String] {
        //return ["Option A", "Option B", "Option C"]
        var list: [String] = []
        
        let input = FileHandle.standardInput
        let data = input.readDataToEndOfFile()
        
        if let inputString = String(data: data, encoding: .utf8) {
            list = inputString.components(separatedBy: .newlines).filter { !$0.isEmpty }
        }
        
        return list
    }
}

