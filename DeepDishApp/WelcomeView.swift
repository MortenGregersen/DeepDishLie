//
//  WelcomeView.swift
//  DeepDishApp
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import DeepDishCore
import DeepDishAppCore
import SwiftUI
import TelemetryDeck

struct WelcomeView: View {
    @State private var showsTitle = false
    @State private var showsButtons = false
    @Environment(WelcomeController.self) private var welcomeController
    @Environment(SettingsController.self) private var settingsController
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 0) {
                    Image("AppIcon", bundle: .core)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                        .padding(.vertical)
                    VStack(alignment: .trailing) {
                        Text("Deep Dish Swift")
                            .font(.system(size: 40, weight: .bold))
                    }
                    .opacity(showsTitle ? 1.0 : 0.0)
                }
                .padding(.top, dynamicTypeSize.isAccessibilitySize ? 0 : 24)
                .padding(.bottom, 24)
                if showsButtons {
                    VStack {
                        Text("How do you feel about pizza?")
                        VStack {
                            Button {
                                dismiss(withFeeling: .love)
                            } label: {
                                Label { Text("Love it!") } icon: { Text("😍") }
                                    .frame(maxWidth: .infinity)
                            }
                            .font(.title)
                            Button {
                                dismiss(withFeeling: .like)
                            } label: {
                                Label { Text("Like it") } icon: { Text("😋") }
                                    .frame(maxWidth: .infinity)
                            }
                            Button {
                                dismiss(withFeeling: .okay)
                            } label: {
                                Label { Text("It's okay...") } icon: { Text("😑") }
                                    .frame(maxWidth: .infinity)
                            }
                            Button {
                                dismiss(withFeeling: .dislike)
                            } label: {
                                Label { Text("Don't like it") } icon: { Text("🤢") }
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .buttonStyle(.borderedProminent)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .foregroundStyle(.white)
        .background {
            Image("FabricBackground", bundle: .core)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0)) {
                showsTitle = true
            }
            withAnimation(.bouncy(duration: 1.0)) {
                showsButtons = true
            }
        }
    }

    private func dismiss(withFeeling feeling: Feeling) {
        if !AppEnvironment.inDemoMode {
            TelemetryDeck.signal("initialConfettiIntensity", floatValue: feeling.confettiIntensity)
        }
        withAnimation {
            settingsController.enableRandomConfetti = feeling != .dislike
            settingsController.randomConfettiIntensity = feeling.confettiIntensity
            welcomeController.hasSeenWelcome = true
            welcomeController.showsWelcome = false
            welcomeController.hasJustSeenWelcome = true
        }
    }

    enum Feeling {
        case love, like, okay, dislike

        var confettiIntensity: Double {
            switch self {
            case .love:
                5
            case .like:
                4
            case .okay:
                3
            case .dislike:
                1
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(SettingsController.forPreview())
        .environment(WelcomeController.forPreview(hasSeenWelcome: false))
}
