//
//  EventView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 28/04/2024.
//

import SwiftUI

struct EventView: View {
    let dayName: String
    let event: Event

    var body: some View {
        NavigationStack {
            List {
                if let speakers = event.speakers {
                    let imageHeight = speakers.count == 1 ? 200 : 300 / CGFloat(speakers.count)
                    HStack(spacing: 16) {
                        Spacer()
                        ForEach(speakers) { speaker in
                            Image(speaker.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: imageHeight)
                                .clipShape(Circle())
                                .background {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: imageHeight * 1.05, height: imageHeight * 1.05)
                                }
                        }
                        Spacer()
                    }
                } else if let emoji = event.emoji {
                    HStack {
                        Spacer()
                        VStack {
                            Text(emoji)
                                .font(.system(size: 120))
                        }
                        .frame(width: 200, height: 200)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    Text(event.description)
                        .font(.title)
                    if let speakers = event.speakers {
                        Text(ListFormatter.localizedString(byJoining: speakers.map(\.name)))
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowSeparator(.hidden, edges: .top)
                Text("\(dayName) \(Event.dateFormatter.string(from: event.start)) - \(Event.dateFormatter.string(from: event.end))")
                    .listRowBackground(Color.accentColor)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    EventView(dayName: "Sunday", event: ScheduleController.forPreview().days.first!.events[6])
}
