//
//  ScheduleWidget.swift
//  DeepDishWidget
//
//  Created by Morten Bjerg Gregersen on 15/02/2025.
//

import SwiftUI
import WidgetKit

public struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScheduleWidget.EntryView(entry: entry)
                .foregroundStyle(.white)
                .containerBackground(for: .widget) {
                    Image("FabricBackground", bundle: .core)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(alignment: .bottomTrailing) {
                            Image("WidgetPizza", bundle: .widgetCore)
                                .opacity(0.2)
                                .rotationEffect(.degrees(-25))
                                .offset(x: 0, y: -50)
                        }
                }
        }
        .configurationDisplayName("Schedule")
        .description("See what sessions are up next")
    }
}
