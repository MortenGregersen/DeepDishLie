//
//  Links.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import Foundation

struct Links: Decodable {
    let name: String?
    let bluesky: URL?
    let github: URL?
    let mastodon: URL?
    let threads: URL?
    let twitter: URL?
    let youtube: URL?
    let website: URL?
}
