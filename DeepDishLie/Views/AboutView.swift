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
                Section {
                    Text("Deep Dish Lie was made for the attendees at the Deep Dish Swift conference 2023.")
                }
                Section("The conference 🍕") {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Deep Dish Swift")
                                    .font(.title)
                                Text("A supreme **Swift** developer conference being served in **Chicago, Illinois**.")
                            }
                            Spacer(minLength: 8)
                            Image("DeepDishSwiftLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1/2 day of indie development talks")
                            Text("2 days of Swift and iOS talks")
                        }
                    }
                }
                Section("Made by 🧑🏽‍💻") {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("This app was made by me, **Morten Bjerg Gregersen**")
                                Text("You can find me at the **Deep Dish Swift this year**.")
                                Text("A **list of my apps** are available on **[CoolYellowOwl.com](https://CoolYellowOwl.com)**")
                            }
                            .frame(maxHeight: .infinity)
                            Spacer(minLength: 8)
                            Image("Morten")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 100)
                                .padding(.top, 8)
                        }
                        Divider()
                        HStack {
                            Text("If you read this, I suspect, that you are an **app developer yourself**. If so maybe my app, **[AppDab](https://AppDab.app)**, is something for you?")
                            Spacer(minLength: 8)
                            Image("AppDabIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                        }
                        Text("It is a **native macOS app** for **App Store Connect** and the **Apple Developer Portal**. Find me at the conference and **get a free sticker!** 🎉🕺")
                    }
                    .padding(.bottom, 8)
                }
            }
            .navigationTitle("About Deep Dish Lie")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
