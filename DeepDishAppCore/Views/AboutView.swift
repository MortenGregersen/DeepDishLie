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
                    Text("Deep Dish Unofficial was made for the attendees at the Deep Dish Swift 2025 conference.")
                    HStack {
                        Text("It is open source and available on [GitHub](https://github.com/MortenGregersen/DeepDishLie).")
                        Spacer()
                        Image("github")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                    }
                }
                Section("The conference 🍕") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Deep Dish Swift")
                                .font(.title)
                            Text("A supreme **Swift** developer conference being served in **Chicago, Illinois**. [Read more](https://deepdishswift.com).")
                        }
                        Spacer(minLength: 8)
                        ZStack {
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
                    }
                }
                Section("The developer 🧑🏽‍💻") {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("This app was made by me, **Morten Bjerg Gregersen**")
                                Text("You can find me at the **Deep Dish Swift this year**.")
                                Text("Find my apps on **[AtterdagApps.com](https://CoolYellowOwl.com)**")
                            }
                            .frame(maxHeight: .infinity)
                            Spacer(minLength: 8)
                            Link(destination: URL(string: "https://AtterdagApps.com")!) {
                                Image("Morten")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .frame(width: 100)
                                    .padding(.top, 8)
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("If you attend the conference, I suspect, that you are an **app developer yourself**. If so, maybe my app, **[AppDab](https://AppDab.app)**, is something for you?")
                            Spacer(minLength: 8)
                            Link(destination: URL(string: "https://AppDab.app")!) {
                                Image("AppDabIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                            }
                        }
                        Text("It is a **native macOS and iOS app** for **App Store Connect**. Find me at the conference and **get a free sticker!** 🎉🕺")
                    }
                    .padding(.bottom, 8)
                }
                Section {
                    Text("Josh and Kari for organizing [Deep Dish Swift](https://deepdishswift.com) 🍕")
                    Text("Simon Bachmann for [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI) 🎉")
                } header: {
                    Text("Thanks go out to 😍")
                } footer: {
                    Text("Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!) (\(Bundle.main.infoDictionary!["CFBundleVersion"]!))")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("About Deep Dish Unofficial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    AboutView()
}
