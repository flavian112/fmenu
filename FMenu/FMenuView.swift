import SwiftUI

struct FMenuView: View {
    
    let searchList: [String]
    
    @State private var searchString: String = ""
    
    @FocusState private var isFocused: Bool
    
    @State private var selectedOption: Int? = nil
    
    private var filteredOptions: [String] {
        let arr: [String]
        if (args.caseInsensitive) {
            arr = searchList.filter { searchString.isEmpty || $0.localizedCaseInsensitiveContains(searchString) }
        } else {
            arr = searchList.filter { searchString.isEmpty || $0.localizedStandardContains(searchString) }
        }
        return Array(arr.prefix(50))
    }
    
    
    var body: some View {
        HStack {
            Text(args.prompt)
                .foregroundStyle(.black)
                .background(.white)
            CustomTextField(text: $searchString)
                .frame(width: 200)
                .focused($isFocused)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(filteredOptions.enumerated()), id: \.element) { index, option in
                        if (index == selectedOption) {
                            Text(option)
                                .padding([.leading, .trailing], 5)
                                .foregroundStyle(color(args.colorSelectedForeground))
                                .background(color(args.colorSelectedBackground))
                        } else {
                            Text(option)
                                .padding([.leading, .trailing], 5)
                                .foregroundStyle(color(args.colorForeground))
                                .background(color(args.colorBackground))
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
        return Color(red: Double(color.red) / 255.0, green: Double(color.green) / 255.0, blue: Double(color.blue) / 255.0)
    }
}
