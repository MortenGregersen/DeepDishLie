//
//  ScheduleView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 24/04/2024.
//

import SwiftUI

struct ScheduleView: View {
    @Environment(ScheduleController.self) private var scheduleController

    var body: some View {
        NavigationStack {
            List(scheduleController.days) { day in
                Section {
                    ForEach(day.events) { event in
                        EventRow(dayName: day.name, event: event)
                            .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 12))
                    }
                } header: {
                    Text(day.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Schedule 🍕")
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

private struct EventRow: View {
    let dayName: String
    let event: Event
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationLink {
            EventView(dayName: dayName, event: event)
        } label: {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .trailing) {
                    Text(Event.dateFormatter.string(from: event.start))
                    Text(Event.dateFormatter.string(from: event.end))
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.accentColor)
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / dateFrameDivider
                }
                VStack(alignment: .leading) {
                    Text(event.description)
                        .font(.headline)
                    if let speakers = event.speakers {
                        Text(ListFormatter.localizedString(byJoining: speakers.map(\.name)))
                            .foregroundStyle(.secondary)
                    }
                }
                if let speakers = event.speakers {
                    Spacer(minLength: 12)
                    if horizontalSizeClass == .compact {
                        VStack(alignment: .trailing) {
                            speakerImages(speakers: speakers)
                        }
                    } else {
                        HStack {
                            speakerImages(speakers: speakers)
                        }
                    }
                } else if let emoji = event.emoji {
                    Spacer(minLength: 12)
                    VStack(alignment: .trailing) {
                        VStack {
                            Text(emoji)
                                .font(.largeTitle)
                        }
                        .frame(width: 50, height: 50)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                    }
                }
            }
        }
        .listRowBackground(listRowBackgroundColor)
    }

    private func speakerImages(speakers: [Speaker]) -> some View {
        ForEach(speakers) { speaker in
            Image(speaker.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .clipShape(Circle())
                .background {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 54, height: 54)
                }
        }
    }

    private var listRowBackgroundColor: Color? {
        switch event {
        case .practical:
            Color.accentColor.opacity(0.2)
        case .session:
            nil
        case .special:
            Color.accentColor.opacity(0.1)
        case .pause:
            Color.accentColor.opacity(0.3)
        case .breakfast:
            Color.accentColor.opacity(0.4)
        case .lunch:
            Color.accentColor.opacity(0.4)
        }
    }

    private var dateFrameDivider: CGFloat {
        switch dynamicTypeSize {
        case .xSmall:
            6
        case .small:
            6
        case .medium:
            6
        case .large:
            5
        case .xLarge:
            4
        case .xxLarge:
            4
        case .xxxLarge:
            4
        case .accessibility1:
            3
        case .accessibility2:
            3
        case .accessibility3:
            2
        case .accessibility4:
            2
        case .accessibility5:
            2
        @unknown default:
            5
        }
    }
}

#Preview {
    ScheduleView()
        .environment(ScheduleController.forPreview())
}
