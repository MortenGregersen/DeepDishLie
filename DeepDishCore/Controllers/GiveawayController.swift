//
//  GiveawayController.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import Foundation

@Observable
public class GiveawayController {
    public private(set) var giveawayInfo: GiveawayInfo
    private static let cachedJsonFilename = "Giveaway.json"

    public init() {
        if let cachedResponse = Self.loadCachedResponse() {
            giveawayInfo = cachedResponse
        } else {
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "Giveaway", withExtension: "json")!)
            giveawayInfo = try! JSONDecoder().decode(GiveawayInfo.self, from: jsonData)
        }
    }

    private static func loadCachedResponse() -> GiveawayInfo? {
        guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let cachedJsonData = try? Data(contentsOf: cacheFolderURL.appending(component: cachedJsonFilename)) else { return nil }
        return try? JSONDecoder().decode(GiveawayInfo.self, from: cachedJsonData)
    }

    @MainActor public func fetchGiveawayInfo() async {
        do {
            let url = URL(string: "https://raw.githubusercontent.com/MortenGregersen/DeepDishLie/main/DeepDishLie/Giveaway.json")!
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            giveawayInfo = try JSONDecoder().decode(GiveawayInfo.self, from: data)
            guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
            try data.write(to: cacheFolderURL.appending(component: Self.cachedJsonFilename))
        } catch {
            // Fail silently
        }
    }
}

public extension GiveawayController {
    static func forPreview() -> GiveawayController {
        .init()
    }
}
