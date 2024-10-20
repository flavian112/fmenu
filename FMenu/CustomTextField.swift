import SwiftUI
import AppKit

struct CustomTextField: NSViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: CustomTextField

        init(parent: CustomTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                parent.text = textField.stringValue
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.placeholderString = nil
        textField.backgroundColor = NSColor.black
        textField.textColor = NSColor.white
        textField.isBordered = false
        textField.wantsLayer = true
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.focusRingType = .none

        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
}
