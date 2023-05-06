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
            BlinkingEyesView(eyeColor: $eyeColor)
                .onReceive(NotificationCenter.default.publisher(for: NSColorPanel.colorDidChangeNotification)) { notification in
                    guard let colorPanel = notification.object as? NSColorPanel else { return }
                    eyeColor = Color(colorPanel.color)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 500, height: 240)
        .commands {
            // App menu
            CommandGroup(replacing: .appSettings) {
                Button("Eye Color...") {
                    NSColorPanel.shared.color = NSColor(eyeColor)
                    NSColorPanel.shared.orderFront(nil)
                }
            }
            CommandGroup(replacing: .appVisibility) {}
            CommandGroup(replacing: .systemServices) {}

            // File menu
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .saveItem) {}

            // Edit menu
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .undoRedo) {}

            // Window menu
            CommandGroup(replacing: .windowSize) {}
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApplication.shared.windows {
            window.makeFloatingContent()
        }
    }

    func applicationWillUpdate(_ notification: Notification) {
        // hack to remove standard menus
        if let menu = NSApplication.shared.mainMenu {
            for title in ["File", "Edit", "View", "Window", "Help"] {
                if let item = menu.items.first(where: { $0.title == title }) {
                    menu.removeItem(item);
                }
            }
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
