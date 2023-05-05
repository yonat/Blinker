//
//  EyeImage.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

struct EyeImage: View {
    @State var isBlinking = false

    var body: some View {
        ZStack {
            // Eyelids
            Path { path in
                let height = 15.0
                let yOffset = isBlinking ? height : 0.0
                path.move(to: CGPoint(x: -35, y: -yOffset))
                path.addQuadCurve(to: CGPoint(x: 35, y: -yOffset), control: CGPoint(x: 0, y: -height))
                path.closeSubpath()
            }
            .fill(Color.red)
            .shadow(radius: 3, y: 3)
            // Iris and Pupil
            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
            Circle()
                .fill(Color.black)
                .frame(width: 30, height: 30)
                .shadow(radius: 3, y: 3)
            // Highlight
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
                .offset(x: 15, y: -15)
            // Reflection
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
                .offset(x: -10, y: -10)
        }
        .frame(width: 70, height: 70)
        .animation(.easeInOut(duration: 0.3), value: isBlinking)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isBlinking = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isBlinking = false
                    }
                }
            }
        }
    }
}

struct EyeImage_Previews: PreviewProvider {
    static var previews: some View {
        EyeImage()
    }
}
