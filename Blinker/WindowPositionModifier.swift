//
//  WindowPositionModifier.swift
//  Blinker
//
//  Created by Yonat Sharon on 11/05/2023.
//  Based on https://www.woodys-findings.com/posts/positioning-window-macos
//

import SwiftUI

struct HostingWindowFinder: NSViewRepresentable {
   var callback: (NSWindow?) -> ()

    func makeNSView(context: Self.Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { self.callback(view.window) }
        return view
     }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async { self.callback(nsView.window) }
    }
}

struct WindowPositionModifier: ViewModifier {
    @Binding var position: NSPoint

    func body(content: Content) -> some View {
        content.background(
            HostingWindowFinder {
                $0?.setFrameOrigin(position)
            }
        )
    }
}

struct RandomWindowPosition: ViewModifier {
    let every: TimeInterval

    func body(content: Content) -> some View {
        content.background(
            HostingWindowFinder {
                $0?.repeatedlyMoveToRandomPosition(after: every)
            }
        )
    }
}

extension NSWindow {
    func randomPositionForOrigin() -> CGPoint {
        guard let screenFrame = NSScreen.screens.randomElement()?.visibleFrame else { return .zero }
        return .init(
            x: .random(in: screenFrame.minX ... max(screenFrame.minX, screenFrame.maxX - frame.width)),
            y: .random(in: screenFrame.minY ... max(screenFrame.minY, screenFrame.maxY - frame.height))
        )
    }

    func repeatedlyMoveToRandomPosition(after: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
            guard let self else { return }
            setFrameOrigin(randomPositionForOrigin())
            repeatedlyMoveToRandomPosition(after: after)
        }
    }
}
