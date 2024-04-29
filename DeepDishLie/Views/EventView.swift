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
    @Environment(\.openURL) private var openURL

    var body: some View {
        List {
            if let speakers = event.speakers {
                Grid(alignment: .center, horizontalSpacing: 24) {
                    GridRow(alignment: .center) {
                        let imageHeight = speakers.count == 1 ? 200 : 300 / CGFloat(speakers.count)
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
                                .shadow(color: .accent, radius: 4)
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
            if let links = event.links {
                linksSection(links: links, header: links.name)
            }
            if let speakers = event.speakers {
                ForEach(speakers) { speaker in
                    if let links = speaker.links {
                        linksSection(links: links, header: speakers.count > 1 ? speaker.name : nil)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.accentColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func linksSection(links: Links, header: String? = nil) -> some View {
        Section {
            if let githubURL = links.github {
                socialButton(url: githubURL, text: "GitHub", image: Image("github"))
            }
            if let mastodonURL = links.mastodon {
                socialButton(url: mastodonURL, text: "Mastodon", image: Image("mastodon"))
            }
            if let twitterURL = links.twitter {
                socialButton(url: twitterURL, text: "Twitter", image: Image("twitter"))
            }
            if let youtubeURL = links.youtube {
                socialButton(url: youtubeURL, text: "YouTube", image: Image("youtube"))
            }
            if let websiteURL = links.website {
                socialButton(url: websiteURL, text: "Website", image: Image(systemName: "globe"))
            }
        } header: {
            if let header {
                Text(header)
            }
        }
    }

    private func socialButton(url: URL, text: String, image: Image) -> some View {
        Button {
            openURL(url)
        } label: {
            Label {
                Text(text)
            } icon: {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        EventView(dayName: "Sunday", event: ScheduleController.forPreview().days[1].events[11])
    }
}
