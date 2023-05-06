//
//  FlashingViewModifier.swift
//  Blinker
//
//  Created by Yonat Sharon on 06/05/2023.
//

import Combine
import SwiftUI

/// Flashes view for a short duration every interval of time.
struct Flashing: ViewModifier {
    private let duration: TimeInterval
    @Binding var interval: TimeInterval
    private let animationDuration: TimeInterval

    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var alpha: CGFloat = 0

    /// - Parameters:
    ///   - duration: Duration of single flash
    ///   - interval: Interval between flashes
    ///   - animationDuration: Duration of the show/hide animation
    init(
        duration: TimeInterval = 1,
        interval: Binding<TimeInterval> = .constant(3),
        animationDuration: TimeInterval = 0.25
    ) {
        self.duration = duration
        self.animationDuration = animationDuration
        self._interval = interval
        timer = .init(interval: interval.wrappedValue, forDuration: duration)
    }

    func body(content: Content) -> some View {
        content
            .opacity(alpha)
            .animation(.easeInOut(duration: animationDuration), value: alpha)
            .onReceive(timer) { _ in
                alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    alpha = 0
                }
            }
            .onChange(of: interval) { newValue in
                timer = .init(interval: newValue, forDuration: duration)
            }
    }
}

struct FlashingViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("bla")
            .modifier(Flashing())
    }
}
