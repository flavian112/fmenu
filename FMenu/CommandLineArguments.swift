import Foundation
import ArgumentParser

struct CommandLineArguments: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "fmenu",
        abstract: "fmenu is a dynamic menu for macOS (dmenu clone), which reads a list of newline-separated items from stdin. When the user selects an item and presses Return, their choice is printed to stdout and dmenu terminates. Entering text will narrow the items to those matching the tokens in the input."
    )

    @Flag(name: .customShort("b"), help: "fmenu appears at the bottom of the screen.")
    private(set) var bottom = false

    @Flag(name: .customShort("i"), help: "fmenu matches menu items case insensitively.")
    private(set) var caseInsensitive = false

    @Flag(name: .customShort("v"), help: "prints version information to stdout, then exits.")
    private(set) var showVersion = false

    @Option(name: .customShort("l"), help: "fmenu lists items vertically, with the given number of lines.")
    private(set) var lines: Int = 0

    @Option(name: .customShort("p"), help: "defines the prompt to be displayed to the left of the input field.")
    private(set) var prompt: String = ""

    @Option(name: [.customLong("fn", withSingleDash: true)], help: "defines the font or font set used. Format: name:size.")
    var fn: String?

    @Option(name: [.customLong("nb", withSingleDash: true)], help: "defines the normal background color. Format: #RRGGBB.")
    private var nb: String = "#000000"

    @Option(name: [.customLong("nf", withSingleDash: true)], help: "defines the normal foreground color.")
    private var nf: String = "#FFFFFF"

    @Option(name: [.customLong("sb", withSingleDash: true)], help: "defines the selected background color.")
    private var sb: String = "#FFFFFF"

    @Option(name: [.customLong("sf", withSingleDash: true)], help: "defines the selected foreground color.")
    private var sf: String = "#000000"
    
    var colorBackground: Color {
        return colorFromHexString(nb) ?? Color(red: 0x00, green: 0x00, blue: 0x00)
    }
    
    var colorForeground: Color {
        return colorFromHexString(nf) ?? Color(red: 0xff, green: 0xff, blue: 0xff)
    }
    
    var colorSelectedBackground: Color {
        return colorFromHexString(sb) ?? Color(red: 0xff, green: 0xff, blue: 0xff)
    }
    
    var colorSelectedForeground: Color {
        return colorFromHexString(sf) ?? Color(red: 0x00, green: 0x00, blue: 0x00)
    }
    
    struct Color {
        let red: UInt8
        let green: UInt8
        let blue: UInt8
    }
    
    private func colorFromHexString(_ hexString: String) -> Color? {
        guard hexString.count == 7, hexString.hasPrefix("#") else {
            return nil
        }

        let hexColor = String(hexString.dropFirst())

        let redHex = hexColor.prefix(2)
        let greenHex = hexColor.dropFirst(2).prefix(2)
        let blueHex = hexColor.dropFirst(4).prefix(2)

        guard let red = UInt8(redHex, radix: 16),
              let green = UInt8(greenHex, radix: 16),
              let blue = UInt8(blueHex, radix: 16) else {
            return nil
        }

        return Color(red: red, green: green, blue: blue)
    }
    
}


