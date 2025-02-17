//
//  ScheduleWidgetEntryView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 17/02/2025.
//

import DeepDishCore
import SwiftUI
import WidgetKit

struct ScheduleWidgetEntryView: View {
    var entry: ScheduleWidget.Provider.Entry

    var body: some View {
        VStack {
            switch entry.mode {
            case .countdown(let startDate):
                CountdownView(eventDate: startDate)
            case .currentNext(let currentEvent, let nextEvent):
                CurrentNextView(currentEvent: currentEvent, nextEvent: nextEvent, widgetFamily: entry.widgetFamily)
            case .ended:
                EndedView()
            }
        }
    }

    private struct CountdownView: View {
        let eventDate: Date
        @State private var timeRemaining: String?
        private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            VStack {
                if let timeRemaining {
                    VStack {
                        Text("Starts in")
                            .font(.callout)
                        Text(timeRemaining)
                            .font(.title)
                            .fixedSize(horizontal: false, vertical: true)
                            .minimumScaleFactor(0.5)
                    }
                    .monospacedDigit()
                    .contentTransition(.numericText(countsDown: true))
                    .animation(.default, value: timeRemaining)
                } else {
                    VStack(spacing: 8) {
                        Text("The conference has started!")
                            .font(.title2)
                        Text("🍕 Enjoy! 🍕")
                    }
                }
            }
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .onAppear(perform: updateCountdown)
            .onReceive(timer) { _ in updateCountdown() }
        }

        private func updateCountdown() {
            let now = Date()
            let remaining = eventDate.timeIntervalSince(now)
            if remaining > 0 {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = remaining > 86400 ? [.day, .hour, .minute] : [.hour, .minute]
                formatter.unitsStyle = .brief
                timeRemaining = formatter.string(from: remaining) ?? "Calculating..."
            } else {
                timeRemaining = nil
            }
        }
    }

    private struct CurrentNextView: View {
        let currentEvent: Event
        let nextEvent: Event
        let widgetFamily: WidgetFamily

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if widgetFamily != .systemSmall {
                    Text("Now: \(currentEvent.description)")
                        .font(.caption2)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Up next:")
                        .font(.caption)
                        .fontWeight(.bold)
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(nextEvent.description)
                                .font(.body)
                                .minimumScaleFactor(0.5)
                                .layoutPriority(1337)
                            if let speakers = nextEvent.speakers {
                                Text(speakers.map(\.name).formatted(.list(type: .and)))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .minimumScaleFactor(0.5)
                                    .layoutPriority(42)
                            }
                        }
                        if widgetFamily != .systemSmall {
                            Spacer()
                            Group {
                                if let speaker = nextEvent.speakers?.first {
                                    Image(speaker.image, bundle: .core)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 50)
                                        .clipShape(Circle())
                                        .background {
                                            Circle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 54, height: 54)
                                        }

                                } else if let emoji = nextEvent.emoji {
                                    Spacer(minLength: 12)
                                    VStack(alignment: .trailing) {
                                        VStack {
                                            Text(emoji)
                                                .font(.largeTitle)
                                        }
                                        .frame(width: 50, height: 50)
                                        .background(Color.accentColor.opacity(nextEvent.toBeDetermined ? 0.5 : 1.0))
                                        .clipShape(Circle())
                                    }
                                }
                            }
                            .offset(y: -8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private struct EndedView: View {
        var body: some View {
            VStack(spacing: 8) {
                Text("Deep Dish Swift has ended 😔")
                    .font(.title)
                    .fontWeight(.semibold)
                    .layoutPriority(1337)
                    .minimumScaleFactor(0.5)
                Text("Go eat some pizza! 🍕")
                    .layoutPriority(42)
                    .minimumScaleFactor(0.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            
        }
    }
}

#Preview("Small", as: .systemSmall) {
    ScheduleWidget()
} timeline: {
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemSmall, mode: .countdown(until: .now.addingTimeInterval(60*60*24*65.1234)))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemSmall, mode: .currentNext(current: ScheduleController().days[2].events[2], next: ScheduleController().days[2].events[3]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemSmall, mode: .ended)
}

#Preview("Medium", as: .systemMedium) {
    ScheduleWidget()
} timeline: {
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemMedium, mode: .countdown(until: .now.addingTimeInterval(60*60*24*65.1234)))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemMedium, mode: .currentNext(current: ScheduleController().days[2].events[2], next: ScheduleController().days[2].events[3]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemMedium, mode: .ended)
}

#Preview("Large", as: .systemLarge) {
    ScheduleWidget()
} timeline: {
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemLarge, mode: .countdown(until: .now.addingTimeInterval(60*60*24*65.1234)))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemLarge, mode: .currentNext(current: ScheduleController().days[2].events[2], next: ScheduleController().days[2].events[3]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemLarge, mode: .ended)
}

#Preview("Extra large", as: .systemExtraLarge) {
    ScheduleWidget()
} timeline: {
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemExtraLarge, mode: .countdown(until: .now.addingTimeInterval(60*60*24*65.1234)))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemExtraLarge, mode: .currentNext(current: ScheduleController().days[2].events[2], next: ScheduleController().days[2].events[3]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemExtraLarge, mode: .ended)
}
