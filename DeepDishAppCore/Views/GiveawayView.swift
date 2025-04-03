//
//  GiveawayView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import DeepDishCore
import SwiftUI

public struct GiveawayView: View {
    @Environment(GiveawayController.self) private var giveawayController
    private var giveawayInfo: GiveawayInfo { giveawayController.giveawayInfo }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Image("AppDabIcon", bundle: .core)
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
                    VStack(spacing: 0) {
                        Text("1 Year of AppDab Pro")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Including AppDab Intelligence ✨")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    Text("Enter for a chance to win a one-year subscription to AppDab Pro, including access to the features powered by AppDab Intelligence ✨")
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                        .ifOS(.macOS) { $0.frame(maxWidth: 450) }
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
                                Text("Congratulations to the winners! 🎉")
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 4)
                            }
                        } else if !giveawayInfo.channel.isEmpty {
                            Text("Join the raffle by visiting the **\(giveawayInfo.channel)** channel in the Deep Dish Swift 2025 Discord server.")
                                .font(.title3)
                        } else {
                            Text("Details on how to enter the AppDab Pro Raffle will be provided during the Deep Dish Swift 2025 conference.")
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
                            .stroke(Color.accentColor, lineWidth: 2)
                    }
                    .padding(.vertical)
                    Text("Read more about AppDab at [AppDab.app](https://appdab.app) 🕺")
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .navigationTitle("AppDab Pro Raffle")
            #if !os(macOS) && !os(tvOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.accent, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            #endif
        }
    }
}

#Preview {
    GiveawayView()
        .environment(GiveawayController.forPreview())
}
