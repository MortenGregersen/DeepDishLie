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
                            Text(measurementFormatter.string(from: temperature(from: weather)))
                                .font(.system(size: 80))
                                .fontWeight(.semibold)
                            Text("Feels like \(measurementFormatter.string(from: apparentTemperature(from: weather)))")
                                .font(.title2)
                        }
                        .padding(.top, 24)
                        verdict(weather: weather)
                            .padding(.top, 8)
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
                        .padding(.top, 16)
                        if let attribution = weatherController.attribution {
                            VStack(spacing: 8) {
                                Text("Forecast data provided by")
                                    .font(.caption)
                                Link(destination: attribution.legalPageURL) {
                                    VStack(spacing: 4) {
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
                if weatherController.weather != nil, weatherController.fetching {
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
            .navigationTitle("Wu with the Weather")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                Button {
                    Task { await weatherController.fetchWeather() }
                } label: {
                    Label("Refresh weather", systemImage: "arrow.clockwise")
                        .font(.callout)
                }
                .disabled(weatherController.weather == nil || weatherController.fetching)
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
        VStack(spacing: 0) {
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
    }
}

#Preview {
    WeatherView()
        .environment(WeatherController.forPreview())
}
