//
//  AppDelegate.swift
//  FormantBuilder
//
//  Created by ookamitai on 8/5/24.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        initPython()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
