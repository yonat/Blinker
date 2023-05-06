//
//  PulsatingViewModifier .swift
//  CallAbout
//
//  Created by Yonat Sharon on 22/07/2022.
//

import Combine
import SwiftUI

/// Scales view in repeating pulses, like a beating heart
struct Pulsating: ViewModifier {
    private let duration: TimeInterval
    private let scale: CGPoint
    @Binding var interval: TimeInterval

    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var scaleChange: CGFloat = 0

    /// - Parameters:
    ///   - duration: Duration of single pulse
    ///   - interval: Interval between pulses
    ///   - scale: How much to scale up the content (1 = no change)
    init(
        duration: TimeInterval = 0.25,
        interval: Binding<TimeInterval> = .constant(3),
        scale: CGPoint = .init(x: 1.5, y: 1.5)
    ) {
        self.duration = duration
        self.scale = scale
        self._interval = interval
        timer = .init(interval: interval.wrappedValue, forDuration: duration)
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(
                x: 1 + scaleChange * (scale.x - 1),
                y: 1 + scaleChange * (scale.y - 1)
            )
            .animation(.easeInOut(duration: duration), value: scaleChange)
            .onReceive(timer) { _ in
                scaleChange = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    scaleChange = 0
                }
            }
            .onChange(of: interval) { newValue in
                timer = .init(interval: newValue, forDuration: duration)
            }
    }
}

private struct PulsatingHeart: View {
    @State var interval: TimeInterval = 3

    var body: some View {
        VStack {
            Text(interval.description)
            Slider(value: $interval, in: 0.1 ... 10)
            Image(systemName: "heart.fill")
                .font(.system(size: 96))
                .foregroundColor(.red)
                .modifier(Pulsating(interval: $interval))
        }
    }
}

struct PulsatingViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        PulsatingHeart()
    }
}

extension Publishers.Autoconnect<Timer.TimerPublisher> {
    convenience init(interval: TimeInterval, forDuration duration: TimeInterval) {
        let period = interval > 0 ? Swift.max(interval, duration) : TimeInterval.infinity
        self.init(upstream: Timer.publish(every: period, on: .main, in: .common))
    }
}
