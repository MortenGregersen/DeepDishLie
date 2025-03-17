//
//  SocialLinksSection.swift
//  DeepDishAppCore
//
//  Created by Matt Heaney on 23/02/2025.
//

import SwiftUI
import DeepDishCore

struct SocialLinksSection<HeaderView: View>: View {
    @Environment(SettingsController.self) private var settingsController
    @Environment(\.openURL) private var openURL
    let links: Links
    @Binding var shownUrl: URL?

    let header: () -> HeaderView

    var body: some View {
        Section {
            if let githubURL = links.github {
                socialButton(url: githubURL, text: "GitHub", image: Image("github"))
            }
            if let mastodonURL = links.mastodon {
                socialButton(url: mastodonURL, text: "Mastodon", image: Image("mastodon"))
            }
            if let blueskyURL = links.bluesky {
                socialButton(url: blueskyURL, text: "Bluesky", image: Image("bluesky"))
            }
            if let threadsURL = links.threads {
                socialButton(url: threadsURL, text: "Threads", image: Image("threads"))
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
            header()
        }
    }

    private func socialButton(url: URL, text: String, image: Image) -> some View {
        Button {
            if settingsController.openLinksInApp {
                shownUrl = url
            } else {
                openURL(url)
            }
        } label: {
            HStack(alignment: .center, spacing: 12) {
                image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 0) {
                    Text(text)
                        .font(.subheadline)
                    Text(url.absoluteString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
        }
    }
}
