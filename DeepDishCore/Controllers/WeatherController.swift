//
//  WeatherController.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 30/04/2024.
//

import Foundation
import WeatherKit

@Observable
public class WeatherController {
    public private(set) var weather: Weather?
    public private(set) var fetching = false
    public private(set) var errorFetching: Error?
    public private(set) var attribution: WeatherAttribution?
    
    public init() {}

    public func fetchWeather() async {
        fetching = true
        defer { fetching = false }
        do {
            let timestamp = Date.timeIntervalSinceReferenceDate
            weather = try await WeatherService.shared.weather(for: .init(latitude: 41.97445788476879, longitude: -87.86374531902608))
            attribution = try await WeatherService.shared.attribution
            if Date.timeIntervalSinceReferenceDate - timestamp < 1 {
                try await Task.sleep(for: .seconds(0.5))
            }
        } catch {
            errorFetching = error
        }
    }
}

public extension WeatherController {
    static func forPreview() -> WeatherController {
        let controller = WeatherController()
        Task { await controller.fetchWeather() }
        return controller
    }
}
