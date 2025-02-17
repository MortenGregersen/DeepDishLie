//
//  FlickeringPizzaView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 09/02/2025.
//

import DeepDishCore
import SwiftUI

struct FlickeringPizzaView: View {
    let repeating: Bool
    @State private var pizzaOrangeOpacity: Double = 0
    @State private var pizzaYellowOpacity: Double = 0

    var body: some View {
        ZStack {
            Image("PizzaOrange", bundle: .core)
                .resizable()
                .scaledToFit()
                .keyframeAnimator(initialValue: 0.0, repeating: repeating) { content, value in
                    content.opacity(value)
                } keyframes: { _ in
                    KeyframeTrack(\.self) {
                        CubicKeyframe(0.0, duration: 0.495)
                        CubicKeyframe(1.0, duration: 0.495)
                        CubicKeyframe(0.4, duration: 0.495)
                        CubicKeyframe(0.9, duration: 0.495)
                        CubicKeyframe(0.35, duration: 0.495)
                        CubicKeyframe(0.8, duration: 0.495)
                        CubicKeyframe(0.1, duration: 0.495)
                        CubicKeyframe(1.0, duration: 0.495)
                        CubicKeyframe(1.0, duration: 29.04)
                        CubicKeyframe(0.0, duration: 0.165)
                    }
                }
            Image("PizzaYellow", bundle: .core)
                .resizable()
                .scaledToFit()
                .keyframeAnimator(initialValue: 0.0, repeating: repeating) { content, value in
                    content.opacity(value)
                } keyframes: { _ in
                    KeyframeTrack(\.self) {
                        CubicKeyframe(0.0, duration: 0.825)
                        CubicKeyframe(1.0, duration: 0.165)
                        CubicKeyframe(0.4, duration: 0.165)
                        CubicKeyframe(0.9, duration: 0.495)
                        CubicKeyframe(0.2, duration: 0.495)
                        CubicKeyframe(0.5, duration: 0.165)
                        CubicKeyframe(0.1, duration: 1.155)
                        CubicKeyframe(1.0, duration: 0.495)
                        CubicKeyframe(1.0, duration: 29.04)
                        CubicKeyframe(0.0, duration: 0.165)
                    }
                }
        }
    }
}

#Preview {
    FlickeringPizzaView(repeating: true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("SplashBackground"))
}
