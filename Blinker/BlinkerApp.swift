//
//  BlinkerApp.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

@main
struct BlinkerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @State private var eyeColor = Color.teal

    var body: some Scene {
        WindowGroup {
            ContentView(eyeColor: $eyeColor)
                .onReceive(NotificationCenter.default.publisher(for: NSColorPanel.colorDidChangeNotification)) { notification in
                    guard let colorPanel = notification.object as? NSColorPanel else { return }
                    eyeColor = Color(colorPanel.color)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 640)
        .commands {
            CommandMenu("Color") {
                Button(action: {
                    NSColorPanel.shared.color = NSColor(eyeColor)
                    NSColorPanel.shared.orderFront(nil)
                }) {
                    Label("Select Color", systemImage: "eyedropper.full")
                }
            }
        }
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
