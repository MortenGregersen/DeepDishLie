//
//  GiveawayView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import DeepDishCore
import SwiftUI
import TelemetryDeck

public struct GiveawayView: View {
    @State private var showsOfferForAllAlert = false
    @Environment(GiveawayController.self) private var giveawayController
    @Environment(\.openURL) private var openUrl
    private var giveawayInfo: GiveawayInfo { giveawayController.giveawayInfo }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Image("AppDabIcon", bundle: .core)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: OperatingSystem.current == .watchOS ? 100 : 200)
                        .overlay {
                            Image(systemName: "app.gift")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: OperatingSystem.current == .watchOS ? 90 : 172)
                                .foregroundStyle(Color.accent)
                                .fontWeight(.light)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Text("🎉")
                                .font(.system(size: OperatingSystem.current == .watchOS ? 40 : 80))
                                .offset(x: OperatingSystem.current == .watchOS ? 10 : 20)
                        }
                    VStack(spacing: 0) {
                        Text("1 Year of AppDab Pro")
                            .font(OperatingSystem.current == .watchOS ? .title2 : .title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        Text("Including AppDab Intelligence ✨")
                            .font(.title3)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    }
                    Text("Enter for a chance to win a one-year subscription to AppDab Pro, including access to the features powered by AppDab Intelligence ✨")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 8)
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
                                .font(.headline)
                        } else {
                            Text("Details on how to enter the AppDab Pro Raffle will be provided during the Deep Dish Swift 2025 conference.")
                                .font(.headline)
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
                    Text("Read more about AppDab on [AppDab.app](https://AppDab.app) 🕺")
                        .multilineTextAlignment(.center)
                        .fontWeight(giveawayInfo.offerForAllUrl == nil ? .regular : .semibold)
                    if giveawayInfo.offerForAllUrl != nil,
                       OperatingSystem.current == .iOS || OperatingSystem.current == .macOS {
                        Button("But what, if I don't win?") {
                            TelemetryDeck.signal("showOfferForAllAlert")
                            showsOfferForAllAlert = true
                        }
                        .buttonStyle(.bordered)
                        .padding(.top)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .navigationTitle("AppDab Pro Raffle")
            .alert("Don't worry ❤️",
                   isPresented: $showsOfferForAllAlert,
                   presenting: giveawayInfo.offerForAllUrl) {
                offerForAllUrl in
                Button("Redeem Offer") {
                    TelemetryDeck.signal("openOfferForAllUrl")
                    openUrl(offerForAllUrl)
                }
                Button("Not now", role: .cancel) {}
            } message: { _ in
                Text("There is a special offer on AppDab Pro with AppDab Intelligence ✨ for everybody.")
            }
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
