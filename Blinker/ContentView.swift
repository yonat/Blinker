//
//  ContentView.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State var isBlinking = false
    let interval: TimeInterval = 6

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                Image(systemName: "eye.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .opacity(isBlinking ? 0.3 : 1.0)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .onAppear {
                let window = NSApplication.shared.windows.first
                window?.level = .floating
                Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isBlinking.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
