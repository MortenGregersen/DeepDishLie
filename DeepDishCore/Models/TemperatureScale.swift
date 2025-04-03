//
//  TemperatureScale.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 27/04/2024.
//

import Defaults
import Foundation

public enum TemperatureScale: String, Defaults.Serializable {
    case fahrenheit
    case celsius
    case kelvin

    public var unit: UnitTemperature {
        switch self {
        case .fahrenheit: .fahrenheit
        case .celsius: .celsius
        case .kelvin: .kelvin
        }
    }

    public var systemImage: String {
        switch self {
        case .fahrenheit: "thermometer.low"
        case .celsius: "thermometer.high"
        case .kelvin: "thermometer.medium"
        }
    }
}
