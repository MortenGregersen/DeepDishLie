//
//  EventView.swift
//  DeepDishLie
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
    private let headerImageHeight: CGFloat = 30

    var body: some View {
        let dateFormatter = Event.dateFormatter(useLocalTimezone: settingsController.useLocalTimezone, use24hourClock: settingsController.use24hourClock)
        List {
            if let speakers = event.speakers, !speakers.isEmpty {
                Grid(alignment: .center, horizontalSpacing: 24) {
                    GridRow(alignment: .center) {
                        let imageHeight = speakers.count == 1 ? 200 : 300 / CGFloat(speakers.count)
                        Spacer()
                        ForEach(speakers) { speaker in
                            Image(speaker.image, bundle: .core)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: imageHeight)
                                .clipShape(Circle())
                                .background {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: imageHeight * 1.05, height: imageHeight * 1.05)
                                }
                                .shadow(color: .accentColor, radius: 4)
                        }
                        Spacer()
                    }
                }
                .padding(.top)
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
                    Text(speakers.map(\.name).formatted(.list(type: .and)))
                        .foregroundStyle(.secondary)
                }
            }
            .listRowSeparator(.hidden, edges: .top)
            Text("\(dayName) \(dateFormatter.string(from: event.start)) - \(dateFormatter.string(from: event.end))")
                .listRowBackground(Color.accentColor)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            if let links = event.links {
                SocialLinksSection(links: links, shownUrl: $shownUrl) {
                    Group {
                        if let name = links.name {
                            Text(name)
                        }
                    }
                }
            }
            if let speakers = event.speakers {
                ForEach(speakers) { speaker in
                    if let links = speaker.links {
                        SocialLinksSection(links: links, shownUrl: $shownUrl, header: {
                            Label {
                                Text("Connect with \(speaker.firstName)")
                            } icon: {
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
                            .foregroundStyle(.primary)
                        })
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(item: $shownUrl) { presentedUrl in
            SafariView(url: presentedUrl)
                .edgesIgnoringSafeArea(.all)
                .presentationCompactAdaptation(.fullScreenCover)
        }
    }
}

#Preview {
    NavigationStack {
        EventView(dayName: "Sunday", event: ScheduleController.forPreview().days[1].events[9])
    }
}
