//
//  ContentView.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

struct ContentView: View {
    @Binding var eyeColor: Color

    var body: some View {
        GeometryReader { geometry in
            let eyeWidth = geometry.size.width / 2.5
            HStack {
                EyeImage(color: $eyeColor)
                    .frame(width: eyeWidth, height: eyeWidth * 0.8)
                Spacer()
                    .frame(width: eyeWidth / 2)
                EyeImage(color: $eyeColor)
                    .frame(width: eyeWidth, height: eyeWidth * 0.8)
            }
            .modifier(Pulsating(
                pulseDuration: 0.15,
                delay: .constant(1.5),
                scaleFactors: .init(x: 1, y: 0.01))
            )
        }
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(eyeColor: .constant(.brown))
    }
}

// TODO:
// - show once every n secs, for m blinks
