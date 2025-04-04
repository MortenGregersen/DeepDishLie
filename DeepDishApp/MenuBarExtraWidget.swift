//
//  MenuBarExtraWidget.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 02/04/2025.
//

#if os(macOS)
import DeepDishCore
import DeepDishWidgetCore
import SwiftUI

struct MenuBarExtraWidget: View {
    @State private var entry: ScheduleWidget.Entry?

    var body: some View {
        VStack {
            if let entry {
                ScheduleWidget.EntryView(entry: entry)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            ScheduleWidget.Provider().getTimeline(widgetFamily: .systemLarge) { entries in
                entry = entries.entries.first
            }
        }
    }
}
#endif
