//
//  TipJarView.swift
//  DeepDishApp
//
//  Created by Morten Bjerg Gregersen on 28/04/2025.
//

#if canImport(ConfettiSwiftUI)
import ConfettiSwiftUI
#endif
import RevenueCat
import SwiftUI

struct TipJarView: View {
    @State private var confettiTrigger = false
    @Environment(TipJarController.self) private var tipJarController

    var body: some View {
        @Bindable var tipJarController = tipJarController
        NavigationStack {
            VStack {
                if let packages = tipJarController.packages {
                    List {
                        Section("Thank you") {
                            Text("If you enjoy using this app, a tip would be greatly appreciated! 🥰 Thank you for your support! ❤️")
                        }
                        Section("Tips") {
                            ForEach(packages) { package in
                                Button {
                                    tipJarController.purchasePackage(package)
                                } label: {
                                    LabeledContent {
                                        Text(package.storeProduct.localizedPriceString)
                                    } label: {
                                        Label {
                                            VStack(alignment: .leading) {
                                                Text(package.storeProduct.localizedTitle)
                                                    .foregroundStyle(.primary)
                                                Text(package.storeProduct.localizedDescription)
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                        } icon: {
                                            Text(emojisForIds[package.identifier] ?? "🍕")
                                        }
                                    }
                                }
                                .foregroundStyle(.primary)
                            }
                        }
                    }
                    .disabled(tipJarController.purchasing)
                } else if tipJarController.fetching {
                    ProgressView("Fetching tips...")
                } else if let error = tipJarController.error {
                    Text(error.localizedDescription)
                    Button("Retry") {
                        tipJarController.fetchPackages()
                    }
                }
            }
            .navigationTitle("Tip jar")
            .alert("Thank you! 🥰", isPresented: $tipJarController.showsThankYou) {
                Button("No problem") {
                    confettiTrigger.toggle()
                }
            } message: {
                Text("Thank you so much for your support! It means a lot! 🍕")
            }
            #if canImport(ConfettiSwiftUI)
            .overlay(alignment: .top) {
                ConfettiCannon(
                    trigger: $confettiTrigger,
                    num: 20,
                    confettis: [.text("🥰"), .text("❤️"), .text("😘")],
                    confettiSize: 50,
                    rainHeight: 1200,
                    fadesOut: true,
                    openingAngle: .degrees(180),
                    closingAngle: .degrees(0),
                    radius: 160,
                    repetitionInterval: 1,
                    hapticFeedback: false)
            }
            #endif
            #if !os(macOS) && !os(tvOS)
            .toolbarBackground(Color.accent, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarTitleDisplayMode(.inlineLarge)
            #endif
            .refreshable {
                tipJarController.fetchPackages()
            }
        }
    }

    var emojisForIds: [String: String] = [
        "tip_jar_1": "🍕",
        "tip_jar_2": "🧀",
        "tip_jar_3": "🍖",
        "tip_jar_4": "🍽️",
        "tip_jar_5": "🍖",
        "tip_jar_6": "👑",
    ]
}

#Preview {
    TipJarView()
}
