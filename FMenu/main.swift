import SwiftUI
import ArgumentParser

var args = CommandLineArguments()

do {
    var commandLineArguments = CommandLine.arguments
    commandLineArguments.removeFirst(1)
    try args = CommandLineArguments.parse(commandLineArguments)
} catch {
    print("usage: fmenu [-biv] [-l lines] [-p prompt] [-fn font] [-nb color] [-nf color] [-sb color] [-sf color]")
    exit(1)
}

if (args.showVersion) {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    print("fname version: \(appVersion ?? "not defined")")
    exit(0)
}

FMenuApp.main()
