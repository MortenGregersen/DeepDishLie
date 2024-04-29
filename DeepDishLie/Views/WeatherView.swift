//
//  WeatherView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 27/04/2024.
//

import SwiftUI
import WeatherKit

struct WeatherView: View {
    @State private var weather: Weather?
    @State private var fetching = false
    @State private var errorFetching: Error?
    @State private var attribution: WeatherAttribution?
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            VStack {
                if let weather {
                    Spacer()
                    VStack(spacing: 0) {
                        Text("The temperature in Rosemont is")
                        Text(weather.currentWeather.temperature.formatted(.measurement(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(1)))))
                            .font(.system(size: 80))
                            .fontWeight(.semibold)
                        Text("Feels like \(weather.currentWeather.apparentTemperature.formatted(.measurement(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(1)))))")
                            .font(.title2)
                        if let attribution {
                            Link(destination: attribution.legalPageURL) {
                                let imageUrl = colorScheme == .light ? attribution.combinedMarkLightURL : attribution.combinedMarkDarkURL
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 10)
                                } placeholder: {}
                            }
                            .padding(.top, 8)
                        }
                    }
                    Spacer()
                    verdict(weather: weather)
                    Spacer()
                    Button {
                        openURL(URL(string: "https://apps.apple.com/us/app/please-dont-rain/id6444577668")!)
                    } label: {
                        HStack {
                            Image("please-dont-rain")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            VStack(alignment: .leading) {
                                Text("Get more weather info in")
                                Text("Please don't rain")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        if fetching {
                            HStack(spacing: 8) {
                                ProgressView()
                                Text("Refreshing weather...")
                                    .font(.callout)
                            }
                        } else {
                            Button {
                                Task { await fetchWeather() }
                            } label: {
                                Label("Refresh weather", systemImage: "arrow.clockwise")
                                    .font(.callout)
                            }
                        }
                    }
                    .frame(minHeight: 50)
                } else if fetching {
                    ProgressView("Fetching weather...")
                } else if let errorFetching {
                    ContentUnavailableView {
                        Label("Error fetching weather", systemImage: "thermometer.medium.slash")
                    } description: {
                        Text(errorFetching.localizedDescription)
                    } actions: {
                        Button {
                            Task { await fetchWeather() }
                        } label: {
                            Label("Try again", systemImage: "arrow.clockwise")
                                .padding(4)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Wu with the Weather")
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .task {
            await fetchWeather()
        }
    }

    @ViewBuilder private func verdict(weather: Weather) -> some View {
        let info = if weather.currentWeather.temperature.converted(to: .fahrenheit).value < 70 {
            (emoji: "🥶", text: "Chris Wu doesn't like this weather... 👎")
        } else {
            (emoji: "💚", text: "Chris Wu loves this weather! 👍")
        }
        Text(info.emoji)
            .font(.system(size: 80))
        Text(info.text)
            .font(.title)
            .fontWeight(.black)
            .padding(.horizontal, 50)
            .multilineTextAlignment(.center)
    }

    private func fetchWeather() async {
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

#Preview {
    WeatherView()
}
