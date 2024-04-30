//
//  WeatherController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 30/04/2024.
//

import Foundation
import WeatherKit

@Observable
class WeatherController {
    private(set) var weather: Weather?
    private(set) var fetching = false
    private(set) var errorFetching: Error?
    private(set) var attribution: WeatherAttribution?
    
    func fetchWeather() async {
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
