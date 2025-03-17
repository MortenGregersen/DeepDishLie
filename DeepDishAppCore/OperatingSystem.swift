//
//  OperatingSystem.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import Foundation

// Borrowed from Sindre Sorhus' reply on StackOverflow:
// https://stackoverflow.com/questions/61386877/in-swiftui-is-it-possible-to-use-a-modifier-only-for-a-certain-os-target

enum OperatingSystem {
    case macOS
    case iOS
    case tvOS
    case watchOS
    case visionOS

    #if os(macOS)
    static let current = macOS
    #elseif os(iOS)
    static let current = iOS
    #elseif os(tvOS)
    static let current = tvOS
    #elseif os(watchOS)
    static let current = watchOS
    #elseif os(visionOS)
    static let current = visionOS
    #else
    #error("Unsupported platform")
    #endif
}
