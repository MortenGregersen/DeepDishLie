//
//  WelcomeView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var welcomeController: WelcomeController
    @Environment(\.colorScheme) private var colorScheme
    private var backgroundColor: Color {
        if colorScheme == .dark {
            return .init(uiColor: UIColor(white: 0.1, alpha: 0.7))
        } else {
            return .primary.opacity(0.5)
        }
    }

    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 12) {
                    Image("DeepDishLieLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                    Text("Welcome to Deep Dish Lie!")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Here you will find the 2 Truths and a Lie that the speakers told in the Slices podcast.")
                    Text("See if you can guess the lie, and approach the speakers and find out if you guessed correctly.")
                    Text("Have a nice Deep Dish Swift!")
                        .fontWeight(.semibold)
                    Button {
                        withAnimation {
                            welcomeController.hasSeenWelcome = true
                            welcomeController.isShowingWelcome = false
                        }
                    } label: {
                        Text("Let's go!")
                            .padding(.horizontal)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
                }
                .multilineTextAlignment(.center)
                .padding()
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .padding()
            .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .environmentObject(WelcomeController())
            .overlay {
                WelcomeView()
            }
    }
}
