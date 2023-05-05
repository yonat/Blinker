//
//  ContentView.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        EyeImage()
            .modifier(Pulsating(
                pulseDuration: 0.15,
                delay: .constant(1.5),
                scaleFactors: .init(x: 1, y: 0.01))
            )
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// TODO:
// - change eye color
// - show once every n secs, for m blinks
