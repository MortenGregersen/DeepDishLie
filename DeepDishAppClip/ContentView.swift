//
//  ContentView.swift
//  DeepDishAppClip
//
//  Created by Matt Heaney on 22/02/2025.
//

import DeepDishAppCore
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScheduleListView()
                .navigationTitle("Deep Dish Swift 🍕")
                .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
