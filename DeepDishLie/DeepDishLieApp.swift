//
//  DeepDishLieApp.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

@main
struct DeepDishLieApp: App {
    @StateObject private var welcomeController = WelcomeController()
    @StateObject private var lieController: LieController = inDemoMode ? .forPreview(numberOfLiesSolved: 10) : .init()
    @State private var scheduleController = ScheduleController()
    static let inDemoMode = UserDefaults.standard.bool(forKey: "Demo")

    var body: some Scene {
        WindowGroup {
            TabView {
                TruthsAndLiesView()
                    .environmentObject(welcomeController)
                    .environmentObject(lieController)
                    .tabItem {
                        Label("Truths and Lies", systemImage: "person.2.wave.2")
                    }
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "text.badge.star")
                    }
            }
            .task {
                if !Self.inDemoMode {
                    await lieController.fetchLieCases()
                    await scheduleController.fetchEvents()
                }
            }
        }
    }
}
