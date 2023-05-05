//
//  PulsatingView.swift
//  CallAbout
//
//  Created by Yonat Sharon on 22/07/2022.
//

import Combine
import SwiftUI

/// Scales view in repeating pulses, like a beating heart
struct Pulsating: ViewModifier {
    private let pulseDuration: TimeInterval
    private let scaleFactors: CGPoint
    @Binding var delay: TimeInterval

    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var scaleChange: CGFloat = 0

    /// - Parameters:
    ///   - pulseDuration: Duration of single pulse
    ///   - delay: Delay between pulses
    ///   - scaleFactors: How much to scale up the content
    init(
        pulseDuration: TimeInterval = 0.25,
        delay: Binding<TimeInterval> = .constant(3),
        scaleFactors: CGPoint = .init(x: 1.5, y: 1.5)
    ) {
        self.pulseDuration = pulseDuration
        self.scaleFactors = scaleFactors
        self._delay = delay
        timer = .init(delay: delay.wrappedValue, forDuration: pulseDuration)
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(
                x: scaleFactors.x.far(by: scaleChange),
                y: scaleFactors.y.far(by: scaleChange)
            )
            .animation(.easeInOut(duration: pulseDuration), value: scaleChange)
            .onReceive(timer) { _ in
                scaleChange = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + pulseDuration) {
                    scaleChange = 0
                }
            }
            .onChange(of: delay) { newValue in
                timer = .init(delay: newValue, forDuration: pulseDuration)
            }
    }

    private func setTimer(delay: CGFloat) {
        timer = Timer.publish(every: delay, on: .main, in: .common).autoconnect()
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
                .modifier(Pulsating(delay: $interval))
        }
    }
}

struct PulsatingViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        PulsatingHeart()
    }
}

extension CGFloat {
    func far(by: CGFloat) -> CGFloat {
        (self - 1) * by + 1
    }
}

extension Publishers.Autoconnect<Timer.TimerPublisher> {
    convenience init(delay: TimeInterval, forDuration duration: TimeInterval) {
        let period = delay > 0 ? Swift.max(delay, duration) : TimeInterval.infinity
        self.init(upstream: Timer.publish(every: period, on: .main, in: .common))
    }
}
