//
//  FMenuApp.swift
//  FMenu
//
//  Created by Flavian Kaufmann on 17.10.2024.
//

import SwiftUI

struct FMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
