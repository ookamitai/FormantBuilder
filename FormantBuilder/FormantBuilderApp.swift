//
//  FormantBuilderApp.swift
//  FormantBuilder
//
//  Created by ookamitai on 8/5/24.
//

import SwiftUI

@main
struct FormantBuilderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .windowResizability(.contentSize)
    }
}
