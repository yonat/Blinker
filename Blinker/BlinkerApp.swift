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
                .modifier(RandomWindowPosition(every: 12))
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 500, height: 160)
        .commands {
            CommandGroup(replacing: .appSettings) {
                Section {
                    Button("Eye Color...") {
                        NSColorPanel.shared.color = NSColor(eyeColor)
                        NSColorPanel.shared.orderFront(nil)
                    }
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
        NSApplication.shared.removeMenu(title: "File", "Edit", "View", "Window", "Help")
    }
}

extension NSApplication {
    func removeMenu(title: String...) {
        guard let menu = mainMenu else { return }
        for menuTitle in title {
            if let item = menu.items.first(where: { $0.title == menuTitle }) {
                menu.removeItem(item);
            }
        }
    }
}

extension NSWindow {
    func makeFloatingContent() {
        level = .floating
        backgroundColor = .clear
        ignoresMouseEvents = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        tabbingMode = .disallowed
        styleMask.remove(.fullScreen)
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }
}
