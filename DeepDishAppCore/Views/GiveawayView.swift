//
//  GiveawayView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import DeepDishCore
import SwiftUI

struct GiveawayView: View {
    @Environment(GiveawayController.self) private var giveawayController
    private var giveawayInfo: GiveawayInfo { giveawayController.giveawayInfo }

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
                                .foregroundStyle(Color.accent)
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
                    Text("As part of **Deep Dish Swift 2025**,\n**five lucky attendees** will win\n**a year of AppDab Pro!**")
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    VStack {
                        if !giveawayInfo.winners.isEmpty {
                            VStack(alignment: .leading) {
                                Text("The raffle is over, and the winners has been found:")
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 4)
                                ForEach(giveawayInfo.winners, id: \.self) { winner in
                                    Text("• \(winner)")
                                }
                            }
                        } else if !giveawayInfo.channel.isEmpty {
                            Text("Join the raffle by going to the **\(giveawayInfo.channel)** channel in the Deep Dish Swift 2025 Discord")
                                .font(.title3)
                        } else {
                            Text("Information on how to attend will be announced at the conference.")
                                .font(.title3)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.accentColor.opacity(0.4))
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 3)
                    }
                    .padding(.vertical)
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .navigationTitle("AppDab Pro Raffle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.accent, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    GiveawayView()
        .environment(GiveawayController.forPreview())
}
