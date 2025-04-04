//
//  WeatherView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 27/04/2024.
//

import DeepDishCore
import SwiftUI
import WeatherKit

public struct WeatherView: View {
    @Environment(SettingsController.self) private var settingsController
    @Environment(WeatherController.self) private var weatherController
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openURL) private var openURL
    private let temperatureFont: Font = OperatingSystem.current == .watchOS ? .largeTitle : .system(size: 80)
    private let feelsLikeFont: Font = OperatingSystem.current == .watchOS ? .caption : .title2
    private var refreshToolbarItemPlacement: ToolbarItemPlacement {
        #if os(macOS)
            return .primaryAction
        #else
            return .topBarTrailing
        #endif
    }

    private var measurementFormatter: MeasurementFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter = numberFormatter
        return formatter
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let weather = weatherController.weather {
                        VStack(spacing: 0) {
                            Text("The temperature in Rosemont is")
                                .multilineTextAlignment(.center)
                            Text(measurementFormatter.string(from: temperature(from: weather)))
                                .font(temperatureFont)
                                .fontWeight(.semibold)
                            Text("Feels like \(measurementFormatter.string(from: apparentTemperature(from: weather)))")
                                .font(feelsLikeFont)
                        }
                        .padding(.top, OperatingSystem.current == .watchOS ? 0 : 24)
                        verdict(weather: weather)
                            .padding(.top, 8)
                        if OperatingSystem.current != .watchOS {
                            let pleaseDontRainView = HStack {
                                Image("please-dont-rain", bundle: .core)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: OperatingSystem.current == .tvOS ? 150 : 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                VStack(alignment: .leading) {
                                    Text("Get more weather info in")
                                    Text("Please don't rain")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                            }
                            VStack {
                                if OperatingSystem.current == .tvOS {
                                    pleaseDontRainView
                                } else {
                                    Button {
                                        openURL(URL(string: "https://apps.apple.com/us/app/please-dont-rain/id6444577668")!)
                                    } label: {
                                        pleaseDontRainView
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                            .padding(.top, 16)
                        }
                        if let attribution = weatherController.attribution {
                            VStack(spacing: 8) {
                                Text("Forecast data provided by")
                                    .font(.caption)
                                let attributionView = VStack(spacing: 4) {
                                    let imageUrl = colorScheme == .light ? attribution.combinedMarkLightURL : attribution.combinedMarkDarkURL
                                    AsyncImage(url: imageUrl) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 15)
                                    } placeholder: {}
                                    Text("and other sources")
                                        .font(.caption)
                                }
                                .focusable()
                                if OperatingSystem.current != .watchOS, OperatingSystem.current != .tvOS {
                                    Link(destination: attribution.legalPageURL) {
                                        attributionView
                                    }
                                } else {
                                    attributionView
                                }
                            }
                            .padding(.top, 16)
                        }
                    } else if weatherController.fetching {
                        ProgressView("Fetching weather...")
                    } else if let errorFetching = weatherController.errorFetching {
                        ContentUnavailableView {
                            Label("Error fetching weather", systemImage: "thermometer.medium.slash")
                        } description: {
                            Text(errorFetching.localizedDescription)
                        } actions: {
                            Button {
                                Task { await weatherController.fetchWeather() }
                            } label: {
                                Label("Try again", systemImage: "arrow.clockwise")
                                    .padding(4)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if OperatingSystem.current != .watchOS, weatherController.weather != nil, weatherController.fetching {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("Refreshing weather...")
                            .font(.callout)
                    }
                    .padding(8)
                    .padding(.horizontal, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor.opacity(0.3))
                    )
                    .padding(.bottom)
                }
            }
            .navigationTitle(OperatingSystem.current == .watchOS ? "Weather" : "Wu with the Weather")
            #if !os(macOS) && !os(tvOS)
                .navigationBarTitleDisplayMode(.automatic)
                .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            #endif
                .toolbar {
                    ToolbarItem(placement: refreshToolbarItemPlacement) {
                        if OperatingSystem.current == .watchOS, weatherController.weather != nil, weatherController.fetching {
                            ProgressView()
                        } else {
                            Button {
                                Task { await weatherController.fetchWeather() }
                            } label: {
                                if OperatingSystem.current == .tvOS {
                                    Text("Refresh")
                                } else {
                                    Label("Refresh weather", systemImage: "arrow.clockwise")
                                        .font(.callout)
                                }
                            }
                            .disabled(weatherController.weather == nil || weatherController.fetching)
                        }
                    }
                }
        }
    }

    private func temperature(from weather: Weather) -> Measurement<UnitTemperature> {
        weather.currentWeather.temperature.converted(to: settingsController.temperatureScale.unit)
    }

    private func apparentTemperature(from weather: Weather) -> Measurement<UnitTemperature> {
        weather.currentWeather.apparentTemperature.converted(to: settingsController.temperatureScale.unit)
    }

    @ViewBuilder private func verdict(weather: Weather) -> some View {
        let emojiFont: Font = OperatingSystem.current == .watchOS ? .title : .system(size: 80)
        let textFont: Font = OperatingSystem.current == .watchOS ? .body : .title
        let horizontalPadding: CGFloat = OperatingSystem.current == .watchOS ? 0 : 50
        VStack(spacing: 0) {
            let info = if weather.currentWeather.temperature.converted(to: .fahrenheit).value < 70 {
                (emoji: "🥶", text: "Chris Wu doesn't like this weather... 👎")
            } else {
                (emoji: "💚", text: "Chris Wu loves this weather! 👍")
            }
            Text(info.emoji)
                .font(emojiFont)
            Text(info.text)
                .font(textFont)
                .fontWeight(.black)
                .padding(.horizontal, horizontalPadding)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    WeatherView()
        .environment(SettingsController.forPreview())
        .environment(WeatherController.forPreview())
        .frame(minWidth: 400, minHeight: 500)
}
