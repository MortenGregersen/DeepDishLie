//
//  GiveawayInfo.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import Foundation

public struct GiveawayInfo: Decodable {
    public let channel: String
    public let winners: [String]
    public let offerForAllUrl: String
}
