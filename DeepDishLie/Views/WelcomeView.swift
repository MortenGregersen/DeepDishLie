//
//  WelcomeView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(WelcomeController.self) private var welcomeController
    @Environment(SettingsController.self) private var settingsController
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        if colorScheme == .dark {
            .init(uiColor: UIColor(white: 0.1, alpha: 0.7))
        } else {
            .primary.opacity(0.5)
        }
    }

    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 12) {
                    Image("DeepDishSwiftLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                    Text("Welcome to Deep Dish Unofficial!")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Here you will find the conference schedule and a quick weather forecast.")
                    Text("Have a nice Deep Dish Swift!")
                        .fontWeight(.semibold)
                    Divider()
                    Text("How do you feel about pizza?")
                    VStack {
                        Button {
                            dismiss(withFeeling: .love)
                        } label: {
                            Label { Text("Love it!") } icon: { Text("😍") }
                                .frame(maxWidth: .infinity)
                        }
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
                    .padding(.horizontal)
                    .font(.title3)
                    .buttonStyle(.borderedProminent)
                }
                .multilineTextAlignment(.center)
                .padding()
                .padding(.vertical, 8)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .padding()
            .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }

    private func dismiss(withFeeling feeling: Feeling) {
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
    Color.red
        .overlay {
            WelcomeView()
                .environment(SettingsController.forPreview())
                .environment(WelcomeController.forPreview(hasSeenWelcome: false))
        }
}
