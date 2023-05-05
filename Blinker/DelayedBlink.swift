//
//  DelayedBlink.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

struct DelayedBlink: View {
    @State private var animate = false

        var body: some View {
            Rectangle()
                .foregroundColor(.red)
                .scaleEffect(animate ? 0.2 : 0.1)
                .animation(Animation.easeInOut(duration: 1).repeatCount(2, autoreverses: true))
                .animation(Animation.easeInOut(duration: 1).repeatCount(1, autoreverses: true))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                        animate.toggle()
                    }
                }
        }
}

struct DelayedBlink_Previews: PreviewProvider {
    static var previews: some View {
        DelayedBlink()
    }
}
