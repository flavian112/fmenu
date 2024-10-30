import SwiftUI

struct FMenuView: View {
    
    let searchList: [String]
    @State private var searchString: String = ""
    @State private var selectedOption: Int? = nil
    @FocusState private var isFocused: Bool
    
    private var filteredOptions: [String] {
        let filtered: [String]
        filtered = searchList.filter { searchString.isEmpty ||
            args.caseInsensitive ?
            $0.localizedCaseInsensitiveContains(searchString) :
            $0.localizedStandardContains(searchString)
        }
        return Array(filtered.prefix(50))
    }
    
    
    var body: some View {
        HStack {
            Text(args.prompt)
                .foregroundStyle(color(args.colorSelectedForeground))
                .background(color(args.colorSelectedBackground))
            
            TextField(text: $searchString) {
                Text("")
            }
            .textFieldStyle(PlainTextFieldStyle())
                .foregroundStyle(color(args.colorForeground))
                .background(color(args.colorBackground))
                .frame(width: 200)
                .focused($isFocused)
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { sp in
                    HStack(spacing: 0) {
                        ForEach(Array(filteredOptions.enumerated()), id: \.offset) { index, option in
                            Text(option)
                                .padding([.leading, .trailing], 5)
                                .foregroundStyle(color(index == selectedOption ?
                                                       args.colorSelectedForeground :
                                                        args.colorForeground))
                                .background(color(index == selectedOption ?
                                                  args.colorSelectedBackground :
                                                    args.colorBackground))
                        }
                    }.onChange(of: selectedOption) { _ , newValue in
                        if let newValue = newValue {
                            sp.scrollTo(newValue)
                        } else if (!filteredOptions.isEmpty) {
                            sp.scrollTo(0)
                        }
                    }
                }
            }
            .scrollDisabled(true)
            Spacer()
        }
        .font(.title2)
        .background(color(args.colorBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            isFocused = true
        }
        .onKeyPress(.escape) {
            isFocused = true
            if (selectedOption == nil) {
                NSApp.terminate(nil)
            } else {
                selectedOption = nil
            }
            
            return .handled
        }
        .onKeyPress(.return) {
            enableSystemLibraryLogs()
            if (selectedOption == nil) {
                print(searchString)
            } else {
                print(filteredOptions[selectedOption!])
            }
            NSApp.terminate(nil)
            return .handled
        }
        .onKeyPress(.tab) {
            if (filteredOptions.first != nil) {
                selectedOption = 0
            }
            return .handled
        }
        .onChange(of: searchString) { oldValue, newValue in
            if (newValue != searchList.first) {
                selectedOption = nil
            }
        }
        .onKeyPress(.leftArrow) {
            if (selectedOption == nil) {
                return .ignored
            }
            if (selectedOption! > 0) {
                selectedOption! -= 1
            }
            return .handled
        }
        .onKeyPress(.rightArrow) {
            if (selectedOption == nil) {
                return .ignored
            }
            if (selectedOption! < filteredOptions.count - 1) {
                selectedOption! += 1
            }
            return .handled
        }
    }
    
    private func color(_ color: CommandLineArguments.Color) -> Color {
        return Color(red: Double(color.red) / 255.0,
                     green: Double(color.green) / 255.0,
                     blue: Double(color.blue) / 255.0)
    }
}
