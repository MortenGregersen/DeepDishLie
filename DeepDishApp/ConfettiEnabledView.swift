//
//  ConfettiEnabledView.swift
//  DeepDishApp
//
//  Created by Morten Bjerg Gregersen on 19/03/2025.
//

import ConfettiSwiftUI
import DeepDishAppCore
import DeepDishCore
import SwiftUI

struct ConfettiEnabledView<Content>: View where Content: View {
    let content: () -> Content
    @State private var showsSettings = false
    @Environment(SettingsController.self) private var settingsController
    @Environment(WelcomeController.self) private var welcomeController
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        @Bindable var settingsController = settingsController
        content()
            .onAppear {
                if welcomeController.hasSeenWelcome, !welcomeController.hasRequestedReview {
                    welcomeController.hasRequestedReview = true
                    requestReview()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                settingsController.triggerConfetti()
            }
            .overlay(alignment: .bottom) {
                if welcomeController.hasJustSeenWelcome, settingsController.randomConfettiIntensity > 4 {
                    VStack {
                        Button {
                            welcomeController.hasJustSeenWelcome = false
                            showsSettings = true
                        } label: {
                            HStack(alignment: .center) {
                                Text("🤪")
                                    .font(.largeTitle)
                                Text("Okay... I don't love it that much!")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .shadow(color: Color.accentColor, radius: 20)
                        Button {
                            welcomeController.hasJustSeenWelcome = false
                        } label: {
                            HStack(alignment: .center) {
                                Text("😍")
                                    .font(.largeTitle)
                                Text("This is just awesome!")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .shadow(color: Color.accentColor, radius: 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                    .padding(.horizontal)
                }
            }
            .overlay(alignment: .top) {
                ConfettiCannon(trigger: $settingsController.confettiTrigger,
                               num: 10,
                               confettis: [.text("🍕")],
                               confettiSize: 50,
                               rainHeight: 1200,
                               fadesOut: true,
                               openingAngle: .degrees(180),
                               closingAngle: .degrees(0),
                               radius: 160,
                               repetitionInterval: 1)
            }
            .sheet(isPresented: $showsSettings) {
                SettingsView()
            }
    }
}

#Preview {
    ConfettiEnabledView {
        Text("Hello, World!")
    }
    .environment(SettingsController.forPreview())
    .environment(WelcomeController.forPreview(hasSeenWelcome: false))
}
