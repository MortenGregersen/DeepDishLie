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
    @State private var shownUrl: PresentedURL?
    @Environment(\.openURL) private var openURL
    @Environment(SettingsController.self) private var settingsController

    var body: some View {
        let dateFormatter = Event.dateFormatter(useLocalTimezone: settingsController.useLocalTimezone, use24hourClock: settingsController.use24hourClock)
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
            Text("\(dayName) \(dateFormatter.string(from: event.start)) - \(dateFormatter.string(from: event.end))")
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
                        linksSection(links: links, header: "Connect with \(speaker.firstName)")
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.accentColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(item: $shownUrl) { presentedUrl in
            SafariView(url: presentedUrl.url)
                .edgesIgnoringSafeArea(.all)
                .presentationCompactAdaptation(.fullScreenCover)
        }
    }

    private func linksSection(links: Links, header: String?) -> some View {
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
            if settingsController.openLinksInApp {
                shownUrl = .init(url: url)
            } else {
                openURL(url)
            }
        } label: {
            Label {
                Text(text)
            } icon: {
                image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .foregroundStyle(.primary)
        }
    }

    private struct PresentedURL: Identifiable {
        let id = UUID()
        let url: URL
    }
}

#Preview {
    NavigationStack {
        EventView(dayName: "Sunday", event: ScheduleController.forPreview().days[1].events[9])
    }
}
