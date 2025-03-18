//
//  SocialLinksSection.swift
//  DeepDishAppCore
//
//  Created by Matt Heaney on 23/02/2025.
//

import DeepDishCore
import SwiftUI

struct SocialLinksSection<HeaderView: View>: View {
    @Environment(SettingsController.self) private var settingsController
    @Environment(\.openURL) private var openURL
    let links: Links
    @Binding var shownUrl: URL?

    let header: () -> HeaderView

    var body: some View {
        Section {
            if let githubURL = links.github {
                socialButton(url: githubURL, text: "GitHub", image: Image("github", bundle: .core))
            }
            if let mastodonURL = links.mastodon {
                socialButton(url: mastodonURL, text: "Mastodon", image: Image("mastodon", bundle: .core))
            }
            if let blueskyURL = links.bluesky {
                socialButton(url: blueskyURL, text: "Bluesky", image: Image("bluesky", bundle: .core))
            }
            if let threadsURL = links.threads {
                socialButton(url: threadsURL, text: "Threads", image: Image("threads", bundle: .core))
            }
            if let twitterURL = links.twitter {
                socialButton(url: twitterURL, text: "Twitter", image: Image("twitter", bundle: .core))
            }
            if let youtubeURL = links.youtube {
                socialButton(url: youtubeURL, text: "YouTube", image: Image("youtube", bundle: .core))
            }
            if let websiteURL = links.website {
                socialButton(url: websiteURL, text: "Website", image: Image(systemName: "globe"))
            }
        } header: {
            header()
        }
    }

    @ViewBuilder private func socialButton(url: URL, text: String, image: Image) -> some View {
        let label = HStack(alignment: .center, spacing: 12) {
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
        #if canImport(SafariServices)
        Button {
            if settingsController.openLinksInApp {
                shownUrl = url
            } else {
                openURL(url)
            }
        } label: {
            label
                .foregroundStyle(.primary)
        }
        #else
        label
        #endif
    }
}

#Preview {
    List {
        SocialLinksSection(links: .init(
            name: "Morten Bjerg Gregersen",
            bluesky: URL(string: "https://bsky.app/profile/mortengregersen.dk")!,
            github: URL(string: "https://github.com/MortenGregersen")!,
            mastodon: URL(string: "https://mastodon.social/@mortengregersen")!,
            threads: URL(string: "https://www.threads.net/@mortengregersen")!,
            twitter: URL(string: "https://x.com/mortengregersen")!,
            youtube: URL(string: "https://www.youtube.com/@appdab6189")!,
            website: URL(string: "http://atterdagapps.com")!),
        shownUrl: .constant(nil),
        header: {
            Text("Connect with Morten")
        })
    }
    .environment(SettingsController.forPreview())
}
