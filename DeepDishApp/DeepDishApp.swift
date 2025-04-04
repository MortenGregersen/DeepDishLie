//
//  DeepDishApp.swift
//  DeepDishApp
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import DeepDishAppCore
import DeepDishCore
#if canImport(DeepDishWidgetCore)
import DeepDishWidgetCore
#endif
import SwiftUI
import TelemetryDeck

@main
struct DeepDishApp: App {
    @State private var welcomeController = WelcomeController(inDemoMode: AppEnvironment.inDemoMode)
    @State private var settingsController = SettingsController()
    @State private var scheduleController: ScheduleController
    @State private var weatherController = WeatherController()
    @State private var giveawayController = GiveawayController()
    @State private var selectedTab: Tab
    #if !os(tvOS)
    @Environment(\.openWindow) private var openWindow
    #endif
    @Environment(\.scenePhase) private var scenePhase
    private let mainWindowId = "MainWindow"
    private let countdownDate: Date?

    init() {
        if !AppEnvironment.inDemoMode {
            TelemetryDeck.initialize(config: .init(appID: "5DD04C64-E9D4-4FB0-AAD6-A48330771CBF"))
        }
        let scheduleController = ScheduleController()
        countdownDate = if !AppEnvironment.inDemoMode, let firstEventDate = scheduleController.firstEventDate, Date.now < firstEventDate {
            firstEventDate
        } else {
            nil
        }
        _scheduleController = .init(initialValue: scheduleController)
        _selectedTab = .init(initialValue: countdownDate != nil ? .countdown : .schedule)
    }

    enum Tab {
        case countdown, schedule, weather, giveaway, about
    }

    var body: some Scene {
        #if os(macOS)
        Window("Deep Dish Unofficial", id: mainWindowId) {
            mainWindowBody
                .frame(minWidth: 600, idealWidth: 700, maxWidth: .infinity, minHeight: 720, idealHeight: 900, maxHeight: .infinity)
                .sheet(isPresented: $welcomeController.showsWelcome) {
                    WelcomeView()
                        .frame(minHeight: 570)
                        .environment(welcomeController)
                        .environment(settingsController)
                }
        }
        .commands {
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .undoRedo) {}
            CommandGroup(replacing: .help) {}
            CommandMenu("Tabs") {
                if countdownDate != nil {
                    Button("Countdown") {
                        selectedTab = .countdown
                    }
                    .keyboardShortcut("0", modifiers: .command)
                }
                Button("Schedule") {
                    selectedTab = .schedule
                }
                .keyboardShortcut("1", modifiers: .command)
                Button("Weather") {
                    selectedTab = .weather
                }
                .keyboardShortcut("2", modifiers: .command)
                Button("Giveaway") {
                    selectedTab = .giveaway
                }
                .keyboardShortcut("3", modifiers: .command)
                Button("About") {
                    selectedTab = .about
                }
                .keyboardShortcut("4", modifiers: .command)
            }
        }
        MenuBarExtra("Deep Dish Unofficial", image: "MenuBarExtra", isInserted: .init(get: {
            settingsController.menuBarExtraShown
        }, set: {
            // For some reason this is called multiple time with the same value
            if settingsController.menuBarExtraShown != $0 {
                settingsController.menuBarExtraShown = $0
            }
        })) {
            VStack {
                MenuBarExtraWidget()
                Divider()
                    .padding(.vertical, 8)
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Button {
                            selectedTab = .schedule
                            showMainWindow()
                        } label: {
                            Label("Schedule", systemImage: "person.2.wave.2")
                        }
                        Button {
                            selectedTab = .weather
                            openWindow(id: mainWindowId)
                            showMainWindow()
                        } label: {
                            Label("Weather", systemImage: "thermometer.sun")
                        }
                        Button {
                            selectedTab = .about
                            openWindow(id: mainWindowId)
                            showMainWindow()
                        } label: {
                            Label("About", systemImage: "text.badge.star")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        HStack {
                            Text("🍕 Confetti")
                            Spacer()
                            Toggle("Confetti", isOn: $settingsController.enableRandomConfetti)
                                .toggleStyle(.switch)
                                .labelsHidden()
                        }
                        if settingsController.enableRandomConfetti {
                            Slider(value: $settingsController.randomConfettiIntensity, in: 1 ... 5, step: 1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .buttonStyle(.borderless)
                    .animation(.default, value: settingsController.enableRandomConfetti)
                    Spacer()
                    FlickeringPizzaView(repeating: true)
                        .onTapGesture {
                            settingsController.triggerConfetti()
                        }
                }
            }
            .padding()
            .frame(minWidth: 340)
            .colorScheme(.dark)
            .foregroundStyle(Color.white)
            .background(Color.splashBackground)
        }
        .menuBarExtraStyle(.window)
        .windowResizability(.contentMinSize)
        Settings {
            SettingsView()
                .environment(settingsController)
        }
        .defaultSize(width: 400, height: 400)
        #else
        WindowGroup {
            mainWindowBody
                .fullScreenCover(isPresented: $welcomeController.showsWelcome) {
                    WelcomeView()
                        .environment(welcomeController)
                        .environment(settingsController)
                }
        }
        #endif
    }

    @ViewBuilder private var mainWindowBody: some View {
        ConfettiEnabledView {
            TabView(selection: $selectedTab) {
                if let countdownDate {
                    CountdownView(eventDate: countdownDate)
                    #if !os(macOS)
                        .toolbarBackground(.visible, for: .tabBar)
                    #endif
                        .tabItem {
                            Label("Countdown", systemImage: "timer")
                        }
                        .tag(Tab.countdown)
                }
                ScheduleView()
                    .environment(scheduleController)
                    .tabItem {
                        Label("Schedule", systemImage: "person.2.wave.2")
                    }
                    .tag(Tab.schedule)
                WeatherView()
                    .environment(weatherController)
                    .tabItem {
                        Label("Weather", systemImage: "thermometer.sun")
                    }
                    .tag(Tab.weather)
                GiveawayView()
                    .environment(giveawayController)
                    .tabItem {
                        Label("Giveaway", systemImage: "app.gift")
                    }
                    .tag(Tab.giveaway)
                AboutView()
                    .environment(scheduleController)
                    .tabItem {
                        Label("About", systemImage: "text.badge.star")
                    }
                    .tag(Tab.about)
            }
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    if !AppEnvironment.inDemoMode {
                        TelemetryDeck.signal("confettiStatus", floatValue: settingsController.randomConfettiIntensity)
                    }
                    Task {
                        await scheduleController.fetchEvents()
                        await weatherController.fetchWeather()
                        await giveawayController.fetchGiveawayInfo()
                    }
                }
            }
            .onOpenURL { url in
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                      components.scheme == "deepdishunofficial",
                      components.host == "event",
                      let queryItems = components.queryItems,
                      let idItem = queryItems.first(where: { $0.name == "id" }),
                      let eventId = idItem.value,
                      let event = scheduleController.days.flatMap(\.events).first(where: { $0.id == eventId })
                else {
                    return
                }
                selectedTab = .schedule
                scheduleController.selectedEvent = event
            }
        }
        .environment(welcomeController)
        .environment(settingsController)
    }

    #if os(macOS)
    private func showMainWindow() {
        openWindow(id: mainWindowId)
        for window in NSApplication.shared.windows {
            if let windowId = window.identifier?.rawValue, windowId == mainWindowId {
                window.makeKeyAndOrderFront(nil)
                window.orderFrontRegardless()
                return
            }
        }
    }
    #endif
}
