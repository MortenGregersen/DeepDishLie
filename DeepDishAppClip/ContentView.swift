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
        NavigationStack {
            EventsListView()
                .navigationTitle("Deep Dish Swift 🍕")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
