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
                        EventRow(event: event)
                    }
                    .listRowInsets(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
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
    let event: Event
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text(event.start.formatted(date: .omitted, time: .shortened))
                Text(event.end.formatted(date: .omitted, time: .shortened))
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
                VStack(alignment: .trailing) {
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
            }
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
            5
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
