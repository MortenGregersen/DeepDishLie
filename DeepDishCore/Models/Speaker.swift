//
//  Speaker.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 26/04/2024.
//

import Foundation

public struct Speaker: Decodable, Equatable, Hashable, Identifiable {
    public var id: String { name }
    public let name: String
    public let image: String
    public let about: String?
    public let fallbackImageUrl: URL?
    public let links: Links?
    public let isDanish: Bool?
    public var firstName: String {
        guard let firstName = name.split(separator: " ").first else { return name }
        return String(firstName)
    }
}
