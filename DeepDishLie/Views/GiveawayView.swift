//
//  GiveawayView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import SwiftUI

struct GiveawayView: View {
    @State private var showsJoiningForm = false
    @Environment(GiveawayController.self) private var giveawayController

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Image("AppDabIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .overlay {
                            Image(systemName: "app.gift")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 172)
                                .foregroundStyle(.accent)
                                .fontWeight(.light)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Text("🎉")
                                .font(.system(size: 80))
                                .offset(x: 20)
                        }
                    Text("1 year of AppDab Pro")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("As part of **Deep Dish Swift 2024**,\n**five lucky attendees** will win\n**a year of AppDab Pro**!")
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    if let winners = giveawayController.winners, !winners.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Winners:")
                                .font(.headline)
                            ForEach(winners, id: \.self) { winner in
                                Text(winner)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(Color.accentColor.opacity(0.4))
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentColor, lineWidth: 3)
                        }
                        .padding(.vertical)
                    } else if giveawayController.hasJoinedGiveaway {
                        VStack {
                            Text("You have joined the Giveaway! ")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text("Good luck! 🍀")
                                .font(.title2)
                        }
                        .padding(.vertical, 16)
                    } else {
                        Button("Join the Giveaway") {
                            showsJoiningForm = true
                        }
                        .font(.title2)
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    VStack(spacing: 8) {
                        Text("When joining, participants may choose to enter their email address to receive updates about future releases of [AppDab](https://AppDab.app).\n**This is not required to win.**")
                        Text("The prize must be collected from Morten Bjerg Gregersen before the end of the conference.")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
                .padding(.top)
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("AppDab Giveaway")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.accent, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showsJoiningForm) {
                GiveawayJoinFormView()
                    .environment(giveawayController)
            }
        }
    }
}

#Preview {
    GiveawayView()
        .environment(GiveawayController())
}
