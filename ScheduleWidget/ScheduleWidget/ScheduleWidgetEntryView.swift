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
            case .currentNext(let currentEvent, let nextEvents):
                CurrentNextView(currentEvent: currentEvent, nextEvents: nextEvents, widgetFamily: entry.widgetFamily)
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
        let currentEvent: Event?
        let nextEvents: [Event]
        let widgetFamily: WidgetFamily

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if widgetFamily != .systemSmall, let currentEvent {
                    Text("**Now:** \(currentEvent.description)")
                        .font(.system(size: 14))
                }
                if let nextEvent = nextEvents.first {
                    VStack(alignment: .leading, spacing: 4) {
                        let upNext = Text("Up next (\(nextEvent.start.formatted(date: .omitted, time: .shortened))):")
                            .font(.caption)
                            .fontWeight(.bold)
                        ViewThatFits(in: .horizontal) {
                            upNext.fixedSize(horizontal: false, vertical: true)
                            upNext.minimumScaleFactor(0.5)
                        }
                        EventRow(event: nextEvent, showTime: false, widgetFamily: widgetFamily)
                            .layoutPriority(1337)
                            .id(nextEvent.id)
                        if widgetFamily == .systemLarge || widgetFamily == .systemExtraLarge {
                            ForEach(nextEvents.dropFirst()) { event in
                                Divider()
                                    .background(.white.opacity(0.2))
                                EventRow(event: event, showTime: true, widgetFamily: widgetFamily)
                                    .layoutPriority(42)
                                    .id(event.id)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }

        private struct EventRow: View {
            let event: Event
            let showTime: Bool
            let widgetFamily: WidgetFamily

            var subtitle: String? {
                var subtitleComponents = [String]()
                if showTime {
                    subtitleComponents.append("at \(event.start.formatted(date: .omitted, time: .shortened))")
                }
                if let speakers = event.speakers, !speakers.isEmpty {
                    subtitleComponents.append(speakers.map(\.name).formatted(.list(type: .and)))
                }
                guard !subtitleComponents.isEmpty else { return nil }
                return subtitleComponents.joined(separator: " with ")
            }

            var body: some View {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        let title = Text(event.description)
                            .font(.body)
                            .foregroundStyle(event.toBeDetermined ? .secondary : .primary)
                        ViewThatFits(in: .horizontal) {
                            title.fixedSize(horizontal: false, vertical: true)
                            title.minimumScaleFactor(0.5)
                        }
                        .layoutPriority(1337)
                        if let subtitle {
                            let subtitle = Text(subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            ViewThatFits {
                                subtitle.fixedSize(horizontal: false, vertical: true)
                                subtitle.minimumScaleFactor(0.8)
                            }
                            .layoutPriority(42)
                        }
                    }
                    Spacer(minLength: 0)
                    if widgetFamily != .systemSmall {
                        Spacer()
                        Group {
                            if let speaker = event.speakers?.first {
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
                                    .id(speaker.id)

                            } else if let emoji = event.emoji {
                                emojiView(emoji: emoji)
                                    .id(emoji)
                            }
                        }
                    }
                }
                if widgetFamily == .systemSmall, !event.id.hasPrefix("special"), let emoji = event.emoji {
                    HStack {
                        Spacer()
                        emojiView(emoji: emoji)
                    }
                    .padding(.top, 4)
                }
            }

            private func emojiView(emoji: String) -> some View {
                VStack(alignment: .trailing) {
                    VStack {
                        Text(emoji)
                            .font(.largeTitle)
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.emojiBackground.opacity(event.toBeDetermined ? 0.5 : 1.0))
                    .clipShape(Circle())
                }
            }
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
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemSmall, mode: .currentNext(currentEvent: ScheduleController().days[2].events[2], nextEvents: [ScheduleController().days[2].events[3]]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemSmall, mode: .ended)
}

#Preview("Medium", as: .systemMedium) {
    ScheduleWidget()
} timeline: {
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemMedium, mode: .countdown(until: .now.addingTimeInterval(60*60*24*65.1234)))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemMedium, mode: .currentNext(currentEvent: ScheduleController().days[2].events[2], nextEvents: [ScheduleController().days[2].events[3]]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemMedium, mode: .ended)
}

#Preview("Large", as: .systemLarge) {
    ScheduleWidget()
} timeline: {
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemLarge, mode: .countdown(until: .now.addingTimeInterval(60*60*24*65.1234)))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemLarge, mode: .currentNext(currentEvent: ScheduleController().days[2].events[1], nextEvents: [ScheduleController().days[2].events[2], ScheduleController().days[2].events[3], ScheduleController().days[2].events[4]]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemLarge, mode: .ended)
}

#Preview("Extra large", as: .systemExtraLarge) {
    ScheduleWidget()
} timeline: {
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemExtraLarge, mode: .countdown(until: .now.addingTimeInterval(60*60*24*65.1234)))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemExtraLarge, mode: .currentNext(currentEvent: ScheduleController().days[2].events[2], nextEvents: [ScheduleController().days[2].events[3], ScheduleController().days[2].events[4], ScheduleController().days[2].events[5]]))
    ScheduleWidget.Entry(date: .now, widgetFamily: .systemExtraLarge, mode: .ended)
}
