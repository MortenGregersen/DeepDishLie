//
//  AboutView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

public struct AboutView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("The app ❤️") {
                    Text("Deep Dish Unofficial is made for the attendees at the Deep Dish Swift 2025 conference.")
                    HStack {
                        Text("It is open source and available on [GitHub](https://github.com/MortenGregersen/DeepDishLie).")
                        Spacer()
                        Image("github", bundle: .core)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                    }
                }
                Section("The conference 🍕") {
                    let pizza = ZStack {
                        Image("PizzaOrange", bundle: .core)
                            .resizable()
                            .scaledToFit()
                        Image("PizzaYellow", bundle: .core)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 80)
                    .padding(8)
                    .background(Circle().fill(Color.splashBackground))
                    let texts = VStack(alignment: .leading) {
                        Text("Deep Dish Swift")
                            .font(OperatingSystem.current == .watchOS ? .headline : .title)
                        Text("A supreme **Swift** developer conference being served in **Chicago, Illinois**.")
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if OperatingSystem.current == .watchOS {
                        VStack(alignment: .leading) {
                            pizza
                            texts
                        }
                        .padding(.vertical)
                    } else {
                        HStack {
                            texts
                            Spacer(minLength: 8)
                            pizza
                        }
                    }
                }
                Section("The developer 🧑🏽‍💻") {
                    VStack(alignment: .leading) {
                        let image = Image("Morten", bundle: .core)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 100)
                            .padding(.top, 8)
                        let texts = VStack(alignment: .leading, spacing: 8) {
                            Text("This app was made by me, **Morten Bjerg Gregersen**")
                            Text("You can find me at **Deep Dish Swift again this year**.")
                            Text("Find my apps on **[AtterdagApps.com](https://AtterdagApps.com)**")
                        }
                        .frame(maxHeight: .infinity)
                        if OperatingSystem.current == .watchOS {
                            VStack(alignment: .leading) {
                                image
                                texts
                            }
                            .padding(.vertical)
                        } else {
                            HStack(alignment: .top) {
                                texts
                                Spacer(minLength: 8)
                                image
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        let image = Image("AppDabIcon", bundle: .core)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                        let text = Text("If you attend the conference, I suspect, that you are an **app developer yourself**. If so, maybe my app, **[AppDab](https://AppDab.app)**, is something for you?")
                        if OperatingSystem.current == .watchOS {
                            VStack(alignment: .leading) {
                                image
                                text
                            }
                        } else {
                            HStack {
                                text
                                Spacer(minLength: 8)
                                image
                            }
                        }
                        Text("It is a **native macOS and iOS app** for **App Store Connect**. Find me at the conference and **get a free sticker!** 🎉🕺")
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 8)
                }
                Section {
                    Text("Josh and Kari for organizing [Deep Dish Swift](https://deepdishswift.com) 🍕")
                    if OperatingSystem.current != .watchOS {
                        Text("Simon Bachmann for [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI) 🎉")
                    }
                } header: {
                    Text("Thanks go out to 😍")
                } footer: {
                    Text("Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!) (\(Bundle.main.infoDictionary!["CFBundleVersion"]!))")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle(OperatingSystem.current == .watchOS ? "About" : "About Deep Dish Unofficial")
            .navigationBarTitleDisplayMode(OperatingSystem.current == .watchOS ? .automatic : .inline)
            .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    AboutView()
}
