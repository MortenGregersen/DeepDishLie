//
//  ScheduleView.swift
//  DeepDishWatchApp
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import DeepDishAppCore
import SwiftUI

struct ScheduleView: View {
    var body: some View {
        NavigationView {
            ScheduleListView()
                .navigationTitle("Schedule")
                .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    ScheduleView()
}
