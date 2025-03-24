//
//  EventView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 28/04/2024.
//

import DeepDishCore
import SwiftUI

struct EventView: View {
    let dayName: String
    let event: Event
    @State private var shownUrl: URL?
    @Environment(SettingsController.self) private var settingsController
    private let speakerMaxImageHeight: CGFloat = OperatingSystem.current == .watchOS ? 60 : 200
    private let speakerImageSpacing: CGFloat = OperatingSystem.current == .watchOS ? 8 : 24
    private let speakerImageBorderWidth: CGFloat = OperatingSystem.current == .watchOS ? 2 : 8
    private let headerImageHeight: CGFloat = 30
    private let descriptionFont: Font = OperatingSystem.current == .watchOS ? .headline : .title
    private let emojiFontSize: CGFloat = OperatingSystem.current == .watchOS ? 60 : 120
    private let emojiFrameSize: CGFloat = OperatingSystem.current == .watchOS ? 100 : 200

    var body: some View {
        let dateFormatter = Event.dateFormatter(useLocalTimezone: settingsController.useLocalTimezone, use24hourClock: settingsController.use24hourClock)
        List {
            VStack(alignment: .leading) {
                if let speakers = event.speakers, !speakers.isEmpty {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: speakers.count), alignment: .center, spacing: speakerImageSpacing) {
                        ForEach(speakers) { speaker in
                            ZStack {
                                Circle()
                                    .fill(Color.accentColor)
                                Image(speaker.image, bundle: .core)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .padding(speakerImageBorderWidth / CGFloat(OperatingSystem.current == .watchOS ? 1 : speakers.count))
                            }
                            .shadow(color: .accentColor, radius: 4)
                            .frame(maxHeight: speakerMaxImageHeight)
                        }
                    }
                    .padding(.vertical)
                } else if let emoji = event.emoji {
                    HStack {
                        Spacer()
                        VStack {
                            Text(emoji)
                                .font(.system(size: emojiFontSize))
                        }
                        .frame(width: emojiFrameSize, height: emojiFrameSize)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        Spacer()
                    }
                    .padding(.vertical)
                }
                Text(event.description)
                    .font(descriptionFont)
                if let speakers = event.speakers {
                    Text(speakers.map(\.name).formatted(.list(type: .and)))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom)
            #if os(iOS)
                .listRowSeparator(.hidden, edges: .top)
            #endif
            Group {
                if OperatingSystem.current == .watchOS {
                    VStack(alignment: .leading) {
                        Text(dayName)
                        Text("\(dateFormatter.string(from: event.start)) - \(dateFormatter.string(from: event.end))")
                    }
                } else {
                    Text("\(dayName) \(dateFormatter.string(from: event.start)) - \(dateFormatter.string(from: event.end))")
                }
            }
            .listRowBackground(Color.accentColor)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            if let links = event.links {
                SocialLinksSection(links: links, shownUrl: $shownUrl) {
                    Group {
                        if let name = links.name {
                            Text(name)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            if let speakers = event.speakers {
                ForEach(speakers) { speaker in
                    if let links = speaker.links {
                        SocialLinksSection(links: links, shownUrl: $shownUrl, header: {
                            HStack {
                                if event.links != nil || speakers.count > 1 {
                                    Image(speaker.image, bundle: .core)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: headerImageHeight)
                                        .clipShape(Circle())
                                        .background {
                                            Circle()
                                                .fill(Color.accentColor)
                                                .frame(width: headerImageHeight * 1.05, height: headerImageHeight * 1.05)
                                        }
                                        .shadow(color: .accentColor, radius: 2)
                                }
                                Text("Connect with \(speaker.firstName)")
                                    .foregroundStyle(.primary)
                            }
                        })
                    }
                }
            }
        }
        .listStyle(.plain)
        #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        #endif
        #if os(iOS)
        .sheet(item: $shownUrl) { presentedUrl in
            SafariView(url: presentedUrl)
                .edgesIgnoringSafeArea(.all)
                .presentationCompactAdaptation(.fullScreenCover)
        }
        #endif
    }

    private func imageWidth(width: CGFloat, items: Int) -> CGFloat {
        let spacing = CGFloat(items - 1) * speakerImageSpacing
        return (width - spacing) / CGFloat(items)
    }
}

#Preview {
    NavigationStack {
        EventView(dayName: "Sunday", event: ScheduleController.forPreview().days[1].events[9])
            .environment(SettingsController.forPreview())
    }
}
