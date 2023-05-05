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
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
