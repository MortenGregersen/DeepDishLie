//
//  EventRow.swift
//  DeepDishAppCore
//
//  Created by Matt Heaney on 22/02/2025.
//

import DeepDishCore
import SwiftUI

struct EventRow: View {
    let dayName: String
    let event: Event
    let dateFormatter: DateFormatter
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private let imageSize: CGFloat = OperatingSystem.current == .watchOS ? 30 : 50
    private let emojiFont: Font = switch OperatingSystem.current {
    case .watchOS: .title3
    case .tvOS: .headline
    default: .largeTitle
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if OperatingSystem.current == .watchOS {
                VStack(alignment: .leading) {
                    Text("\(dateFormatter.string(from: event.start)) - \(dateFormatter.string(from: event.end))")
                        .font(.caption2)
                        .foregroundStyle(event.dateTextColor)
                    Text(event.description)
                        .font(.headline)
                        .foregroundStyle(event.titleTextColor)
                        .italic(event.toBeDetermined)
                    if let speakers = event.speakers {
                        Text(speakers.map(\.name).formatted(.list(type: .and)))
                            .foregroundStyle(event.subtitleTextColor)
                    }
                }
                .padding(.leading)
            } else {
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
                            .font(emojiFont)
                    }
                    .frame(width: imageSize, height: imageSize)
                    .background(Color.accentColor.opacity(event.toBeDetermined ? 0.5 : 1.0))
                    .clipShape(Circle())
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
        SpeakerImage(speaker: speaker)
            .frame(width: imageSize, height: imageSize)
            .clipShape(Circle())
            .background {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: imageSize + 4, height: imageSize + 4)
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

#Preview {
    @Previewable @State var scheduleController = ScheduleController.forPreview()
    @Previewable @State var settingsController = SettingsController.forPreview()
    EventRow(dayName: scheduleController.days.first!.name, event: scheduleController.days.first!.events[3], dateFormatter: Event.dateFormatter(useLocalTimezone: settingsController.useLocalTimezone, use24hourClock: settingsController.use24hourClock))
}
