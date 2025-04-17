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
    #if !os(tvOS)
        @Environment(\.requestReview) private var requestReview
    #endif
    #if os(macOS)
        @State private var confettiManager = MacConfettiManager()
    #endif

    var body: some View {
        @Bindable var settingsController = settingsController
        GeometryReader { geometry in
            content()
                .onAppear {
                    if welcomeController.hasSeenWelcome, !welcomeController.hasRequestedReview {
                        welcomeController.hasRequestedReview = true
                        #if !os(tvOS)
                            requestReview()
                        #endif
                    }
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
                .sheet(isPresented: $showsSettings) {
                    SettingsView()
                }
            #if os(iOS)
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                    settingsController.triggerConfetti()
                }
            #endif
            #if canImport(ConfettiSwiftUI) && canImport(UIKit)
                .overlay(alignment: .top) {
                    ConfettiCannon(
                        trigger: $settingsController.confettiTrigger,
                        num: 10,
                        confettis: [.text("🍕")],
                        confettiSize: geometry.size.height/15,
                        rainHeight: 1200,
                        fadesOut: true,
                        openingAngle: .degrees(180),
                        closingAngle: .degrees(0),
                        radius: geometry.size.width/2,
                        repetitionInterval: 1,
                        hapticFeedback: false)
            }
            #elseif os(macOS)
            .onAppear {
                confettiManager.showConfettiOnAllScreens(trigger: $settingsController.confettiTrigger)
            }
            #endif
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
