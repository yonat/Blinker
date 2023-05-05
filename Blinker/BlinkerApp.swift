//
//  BlinkerApp.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

@main
struct BlinkerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 250, height: 125)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApplication.shared.windows {
            window.makeFloatingContent()
        }
    }
}

extension NSWindow {
    func makeFloatingContent() {
        level = .floating
        backgroundColor = .clear
        isMovableByWindowBackground = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }
}
