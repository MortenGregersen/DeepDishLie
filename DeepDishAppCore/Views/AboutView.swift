//
//  AboutView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import DeepDishCore
import SwiftUI

public struct AboutView: View {
    @Environment(ScheduleController.self) private var scheduleController

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("The app ❤️") {
                    let singleCellOSes: [OperatingSystem] = [.macOS, .tvOS, .visionOS]
                    let topText = Text("Deep Dish Unofficial is made for the attendees at the Deep Dish Swift 2026 conference.")
                    let bottomText = Text("It is open source and available on [GitHub](https://github.com/MortenGregersen/DeepDishLie).")
                    if !singleCellOSes.contains(OperatingSystem.current) {
                        topText
                    }
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            if singleCellOSes.contains(OperatingSystem.current) {
                                topText
                            }
                            bottomText
                        }
                        Spacer()
                        Image("github", bundle: .core)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .ifOS(.macOS) { $0.frame(width: 50) }
                            .ifOS(.tvOS) { $0.frame(width: 80) }
                            .ifOS(.visionOS) { $0.frame(width: 66) }
                            .ifNotOS(.macOS, .tvOS, .visionOS) { $0.frame(width: 40) }
                    }
                }
                Section("The conference 🍕") {
                    let iconImage = Image("DeepDishLogo", bundle: .core)
                        .resizable()
                        .scaledToFit()
                        .ifOS(.macOS, .visionOS) { $0.frame(maxHeight: 60) }
                        .ifNotOS(.macOS, .visionOS) { $0.frame(width: 80) }
                    let texts = VStack(alignment: .leading) {
                        Text("Deep Dish Swift")
                            .font(OperatingSystem.current == .iOS ? .title : .headline)
                        Text("A supreme **Swift** developer conference being served in **Chicago, Illinois**.")
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if OperatingSystem.current == .watchOS {
                        VStack(alignment: .leading) {
                            iconImage
                            texts
                        }
                        .padding(.vertical)
                    } else {
                        HStack(alignment: .top) {
                            texts
                            Spacer(minLength: 8)
                            iconImage
                        }
                    }
                }
                Section("The developer 🧑🏽‍💻") {
                    let image = Image("Morten", bundle: .core)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .ifOS(.macOS) { $0.frame(maxHeight: 80) }
                        .ifOS(.visionOS) { $0.frame(maxHeight: 100) }
                        .frame(width: 100)
                    let developerTexts = VStack(alignment: .leading, spacing: 4) {
                        Text("This app was made by me, **Morten Bjerg Gregersen** 🤓")
                        Text("Unfortunately **I won't be at Deep Dish Swift this year**. See you another time! 👋")
                        Text("Find my apps on **[AtterdagApps.com](https://AtterdagApps.com)** 👑")
                        if OperatingSystem.current == .macOS || OperatingSystem.current == .visionOS {
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    if OperatingSystem.current == .watchOS {
                        VStack(alignment: .leading) {
                            image
                            developerTexts
                        }
                        .padding(.vertical)
                    } else {
                        HStack(alignment: .top) {
                            developerTexts
                            Spacer(minLength: 8)
                            image
                        }
                        .padding(.top, 8)
                    }
                    VStack(alignment: .leading) {
                        let appDabIcon = Image("AppDabIcon", bundle: .core)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .ifOS(.macOS) { $0.frame(maxHeight: 80) }
                            .frame(width: 100)
                        let appDabTopText = Text("If you attend the conference, I suspect, that you are an **app developer yourself**. If so, maybe my app, **[AppDab](https://AppDab.app)**, is something for you?")
                        let appDabBottomText = Text("It is a **native macOS, iOS, and watchOS app** for managing your apps in **App Store Connect** 🚀🕺")
                        if OperatingSystem.current == .watchOS {
                            VStack(alignment: .leading) {
                                appDabIcon
                                appDabTopText
                            }
                        } else {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 8) {
                                    appDabTopText
                                    if OperatingSystem.current == .macOS || OperatingSystem.current == .visionOS {
                                        appDabBottomText
                                    }
                                    if OperatingSystem.current == .visionOS {
                                        Spacer(minLength: 0)
                                    }
                                }
                                .ifOS(.visionOS) { $0.padding(.top, 8) }
                                Spacer(minLength: 8)
                                appDabIcon
                                    .padding(.leading)
                                    .padding(.bottom)
                            }
                            if OperatingSystem.current != .macOS, OperatingSystem.current != .visionOS {
                                appDabBottomText
                            }
                        }
                    }
                }
                Section {
                    Text("Josh and Kari for organizing [Deep Dish Swift](https://deepdishswift.com) 🍕")
                    if let firstEventDate = scheduleController.firstEventDate, Date.now < firstEventDate {
                        Text("Alex Sikora for the inspiration to the countdown from his [DeepDishCountdown.fun](https://deepdishcountdown.fun) ⏲️")
                    }
                    Text("Kai and Malin for making the [Slices](https://podcasts.apple.com/ca/podcast/slices-the-deep-dish-swift-podcast/id1670026071) podcast up to the conference 🎙️")
                    if OperatingSystem.current != .watchOS {
                        Text("Simon Bachmann for [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI) 🎉")
                    }
                } header: {
                    Text("Thanks go out to 😍")
                } footer: {
                    Text(verbatim: "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!) (\(Bundle.main.infoDictionary!["CFBundleVersion"]!))")
                        .frame(maxWidth: .infinity)
                }
                .ifOS(.tvOS) { $0.focusable() }
            }
            .navigationTitle(OperatingSystem.current == .watchOS ? "About" : "About Deep Dish Unofficial")
            #if !os(macOS) && !os(tvOS)
                .navigationBarTitleDisplayMode(OperatingSystem.current == .watchOS ? .automatic : .inline)
            #endif
            .deepDishNavigationBarStyle()
        }
    }
}

#Preview {
    AboutView()
        .frame(minHeight: 500)
        .environment(ScheduleController.forPreview())
}
