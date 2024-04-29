//
//  GiveawayController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import Foundation

@Observable
class GiveawayController {
    private(set) var winners: [String]?
    private static let cachedJsonFilename = "Winners.json"
    
    var hasJoinedGiveaway: Bool {
        didSet { UserDefaults.standard.set(hasJoinedGiveaway, forKey: "has-joined-giveaway") }
    }

    init() {
        self.hasJoinedGiveaway = UserDefaults.standard.bool(forKey: "has-joined-giveaway")
        if let winners = Self.loadCachedWinners() {
            self.winners = winners
        } else {
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "Winners", withExtension: "json")!)
            self.winners = try! JSONDecoder().decode([String].self, from: jsonData)
        }
    }
    
    private static func loadCachedWinners() -> [String]? {
        guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let cachedJsonData = try? Data(contentsOf: cacheFolderURL.appending(component: cachedJsonFilename)) else { return nil }
        return try? JSONDecoder().decode([String].self, from: cachedJsonData)
    }
    
    @MainActor func fetchWinners() async {
        do {
            let url = URL(string: "https://raw.githubusercontent.com/MortenGregersen/DeepDishLie/main/DeepDishLie/Winners.json")!
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            winners = try JSONDecoder().decode([String].self, from: data)
            guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
            try data.write(to: cacheFolderURL.appending(component: Self.cachedJsonFilename))
        } catch {
            // Fail silently
        }
    }
    
    @MainActor func joinTheGiveaway(name: String, email: String) async throws {
        guard let name = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics),
              let email = email.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            throw GiveawayError.encodingInputFailed
        }
        let url = URL(string: "https://docs.google.com/forms/u/0/d/e/1FAIpQLSeefbjvCVkgucbU56SGYPw8LkGcaGUX80C4nNJ47IrCGkaNkg/formResponse")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "entry.888112680=\(name)&entry.1759734038=\(email)"
            .data(using: .utf8)
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                hasJoinedGiveaway = true
                return
            }
            throw GiveawayError.httpError(statusCode: httpResponse.statusCode)
        } else {
            throw GiveawayError.unknown
        }
    }
}

enum GiveawayError: Error, LocalizedError {
    case encodingInputFailed
    case httpError(statusCode: Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .encodingInputFailed:
            "The name or email could not be sent."
        case .httpError(let statusCode):
            "An error occurred while joining.\nHTTP status code: \(statusCode)."
        case .unknown:
            "An unknown error occurred while joining."
        }
    }
}
