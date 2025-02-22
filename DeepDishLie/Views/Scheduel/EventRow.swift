//
//  EventRow.swift
//  DeepDishLie
//
//  Created by Matt Heaney on 22/02/2025.
//

import SwiftUI
import DeepDishCore

struct EventRow: View {
    let dayName: String
    let event: Event
    let dateFormatter: DateFormatter
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationLink {
            EventView(dayName: dayName, event: event)
        } label: {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .trailing) {
                    Text(dateFormatter.string(from: event.start))
                    Text(dateFormatter.string(from: event.end))
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(event.dateTextColor)
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / dateFrameDivider
                }
                VStack(alignment: .leading) {
                    Text(event.description)
                        .font(.headline)
                        .foregroundStyle(event.titleTextColor)
                        .italic(event.toBeDetermined)
                    if let speakers = event.speakers {
                        Text(speakers.map(\.name).formatted(.list(type: .and)))
                            .foregroundStyle(event.subtitleTextColor)
                    }
                }
                if let speakers = event.speakers, !speakers.isEmpty {
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
                        .background(Color.accentColor.opacity(event.toBeDetermined ? 0.5 : 1.0))
                        .clipShape(Circle())
                    }
                }
            }
        }
        .listRowBackground(listRowBackgroundColor)
    }

    @ViewBuilder private func speakerImages(speakers: [Speaker]) -> some View {
        if speakers.count > 2, let speaker = speakers.first {
            speakerImage(speaker)
        } else {
            ForEach(speakers) { speaker in
                speakerImage(speaker)
            }
        }
    }

    private func speakerImage(_ speaker: Speaker) -> some View {
        Image(speaker.image, bundle: .core)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 50)
            .clipShape(Circle())
            .background {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 54, height: 54)
            }
            .shadow(color: .accentColor, radius: 1, x: 0, y: 1)
    }

    private var listRowBackgroundColor: Color? {
        guard event.isHappeningNow else {
            return switch event {
            case .session: nil
            default: Color.accentColor.opacity(0.1)
            }
        }
        return Color.accentColor
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
