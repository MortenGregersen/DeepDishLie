//
//  Links.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import Foundation

public struct Links: Decodable, Equatable {
    public let name: String?
    public let bluesky: URL?
    public let github: URL?
    public let mastodon: URL?
    public let threads: URL?
    public let twitter: URL?
    public let youtube: URL?
    public let website: URL?
    
    public init(name: String?, bluesky: URL?, github: URL?, mastodon: URL?, threads: URL?, twitter: URL?, youtube: URL?, website: URL?) {
        self.name = name
        self.bluesky = bluesky
        self.github = github
        self.mastodon = mastodon
        self.threads = threads
        self.twitter = twitter
        self.youtube = youtube
        self.website = website
    }
}
