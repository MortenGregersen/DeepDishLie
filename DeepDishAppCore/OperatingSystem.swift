//
//  OperatingSystem.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import Foundation
import SwiftUI

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

extension View {
    /**
     Conditionally apply modifiers depending on the target operating system.

     ```
     struct ContentView: View {
         var body: some View {
             Text("Unicorn")
                 .font(.system(size: 10))
                 .ifOS(.macOS, .tvOS) {
                     $0.font(.system(size: 20))
                 }
         }
     }
     ```
     */
    @ViewBuilder
    func ifOS(_ operatingSystems: OperatingSystem..., modifier: (Self) -> some View) -> some View {
        if operatingSystems.contains(OperatingSystem.current) {
            modifier(self)
        } else {
            self
        }
    }
}
