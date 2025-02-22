//
//  ScheduleView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 24/04/2024.
//

import ConfettiSwiftUI
import DeepDishCore
import StoreKit
import SwiftUI

struct ScheduleView: View {
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State private var currentDateId: String?
    @State private var showsSettings = false
    @Environment(\.requestReview) private var requestReview
    @Environment(WelcomeController.self) private var welcomeController
    @Environment(SettingsController.self) private var settingsController
    @Environment(ScheduleController.self) private var scheduleController

    var body: some View {
        @Bindable var settingsController = settingsController
        NavigationStack {
            ScrollViewReader { proxy in
                ScheduleListView()
                    .navigationTitle("Schedule 🍕")
                    .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbar {
                        if let currentDateId {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    withAnimation {
                                        proxy.scrollTo(currentDateId, anchor: .center)
                                    }
                                } label: {
                                    Label("Now", systemImage: "clock")
                                }
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showsSettings = true
                            } label: {
                                Label("Settings", systemImage: "gear")
                            }
                        }
                    }
                    .sheet(isPresented: $showsSettings) {
                        SettingsView()
                    }
                    .onAppear {
                        currentDateId = scheduleController.currentDateEvent?.id
                        if let currentDateId {
                            proxy.scrollTo(currentDateId, anchor: .center)
                        }
                        if welcomeController.hasSeenWelcome, !welcomeController.hasRequestedReview {
                            welcomeController.hasRequestedReview = true
                            requestReview()
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                        settingsController.triggerConfetti()
                    }
                    .overlay(alignment: .bottom) {
                        if welcomeController.hasJustSeenWelcome, settingsController.randomConfettiIntensity > 4 {
                            VStack {
                                Button {
                                    welcomeController.hasJustSeenWelcome = false
                                    showsSettings = true
                                } label: {
                                    HStack(alignment: .center) {
                                        Text("🤪")
                                            .font(.largeTitle)
                                        Text("Okay... I don't love it that much!")
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .shadow(color: Color.accentColor, radius: 20)
                                Button {
                                    welcomeController.hasJustSeenWelcome = false
                                } label: {
                                    HStack(alignment: .center) {
                                        Text("😍")
                                            .font(.largeTitle)
                                        Text("This is just awesome!")
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .shadow(color: Color.accentColor, radius: 20)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.bottom)
                            .padding(.horizontal)
                        }
                    }
            }
        }
        .overlay(alignment: .top) {
            ConfettiCannon(trigger: $settingsController.confettiTrigger,
                           num: 10,
                           confettis: [.text("🍕")],
                           confettiSize: 50,
                           rainHeight: 1200,
                           fadesOut: true,
                           openingAngle: .degrees(180),
                           closingAngle: .degrees(0),
                           radius: 160,
                           repetitionInterval: 1)
        }
        .onReceive(timer) { _ in
            currentDateId = scheduleController.currentDateEvent?.id
        }
    }
}

#Preview {
    ScheduleView()
        .environment(SettingsController.forPreview())
        .environment(ScheduleController.forPreview())
        .environment(WelcomeController.forPreview(hasSeenWelcome: false))
}
