//
//  ScheduleView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 24/04/2024.
//

import DeepDishCore
import StoreKit
import SwiftUI

public struct ScheduleView: View {
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State private var currentDateId: String?
    @State private var showsSettings = false
    @Environment(ScheduleController.self) private var scheduleController

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                EventsListView()
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
                    }
            }
        }
        .onReceive(timer) { _ in
            currentDateId = scheduleController.currentDateEvent?.id
        }
    }
}

#Preview {
    ScheduleView()
        .environment(ScheduleController.forPreview())
}
