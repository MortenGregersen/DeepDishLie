//
//  Links.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import Foundation

public struct Links: Decodable {
    public let name: String?
    public let bluesky: URL?
    public let github: URL?
    public let mastodon: URL?
    public let threads: URL?
    public let twitter: URL?
    public let youtube: URL?
    public let website: URL?
}
