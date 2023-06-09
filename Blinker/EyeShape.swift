//
//  EyeShape.swift
//  Blinker
//
//  Created by Yonat Sharon on 05/05/2023.
//

import SwiftUI

struct EyeShape: View {
    @Binding var color: Color

    init(color: Binding<Color> = .constant(.teal)) {
        self._color = color
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Sclera
                Path { path in
                    let midHeight = geometry.size.height / 2
                    let midWidth = geometry.size.width / 2
                    let startPoint = CGPoint(x: 0, y: midHeight)
                    let endPoint = CGPoint(x: geometry.size.width, y: midHeight)
                    let scleraHeight = midHeight * 0.5
                    path.move(to: startPoint)
                    path.addQuadCurve(
                        to: endPoint,
                        control: CGPoint(x: midWidth, y: -scleraHeight))
                    path.addQuadCurve(
                        to: startPoint,
                        control: CGPoint(x: midWidth, y: midHeight * 2 + scleraHeight)
                    )
                    path.closeSubpath()
                }
                .fill(Color.white)
                .shadow(radius: 5, y: 5)
                // Iris
                Circle()
                    .fill(color)
                    .frame(width: geometry.size.height * 0.7, height: geometry.size.height * 0.7)
                // Pupil
                Circle()
                    .fill(Color.black)
                    .frame(width: geometry.size.height / 3, height: geometry.size.height / 3)
                    .shadow(radius: 3, y: 3)
                // Glare
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: geometry.size.height / 5, height: geometry.size.height / 5)
                    .offset(x: geometry.size.height / 5, y: -geometry.size.height / 5)
                // Reflection
                Circle()
                    .fill(Color.white)
                    .frame(width: geometry.size.height / 10, height: geometry.size.height / 10)
                    .offset(x: -geometry.size.height / 10, y: -geometry.size.height / 10)
            }
        }
    }
}

struct EyeShape_Previews: PreviewProvider {
    static var previews: some View {
        EyeShape()
            .frame(width: 100, height: 80)
    }
}
