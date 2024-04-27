//
//  AboutView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("The app ❤️") {
                    Text("Deep Dish Unofficial was made for the attendees at the Deep Dish Swift 2024 conference.")
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
                        Image("DeepDishSwiftLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
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
                            Text("If you read this, I suspect, that you are an **app developer yourself**. If so, maybe my app, **[AppDab](https://AppDab.app)**, is something for you?")
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
                Section("Thanks go out to 😍") {
                    Text("Josh and Kari for organizing [Deep Dish Swift](https://deepdishswift.com) 🍕")
                    Text("Kai and Malin for making the [Slices](https://podcasts.apple.com/ca/podcast/slices-the-deep-dish-swift-podcast/id1670026071) podcast up to the conference 🎧")
                }
            }
            .navigationTitle("About Deep Dish Unofficial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
