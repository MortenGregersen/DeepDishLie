//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by Morten Bjerg Gregersen on 15/02/2025.
//

import DeepDishCore
import SwiftUI
import WidgetKit

struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
                .foregroundStyle(.white)
                .containerBackground(for: .widget) {
                    Color.widgetBackground
                        .overlay(alignment: .bottomTrailing) {
                            ZStack {
                                Image("PizzaOrange", bundle: .core)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                Image("PizzaYellow", bundle: .core)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                            }
                            .opacity(0.2)
                            .rotationEffect(.degrees(-25))
                            .offset(x: 40, y: 50)
                        }
                }
        }
        .configurationDisplayName("Schedule")
        .description("See what session is up next")
    }
}

