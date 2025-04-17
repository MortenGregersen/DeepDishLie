//
//  OperatingSystem.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import Foundation
import SwiftUI

// Borrowed from Sindre Sorhus' reply on StackOverflow:
// https://stackoverflow.com/questions/61386877/in-swiftui-is-it-possible-to-use-a-modifier-only-for-a-certain-os-target

public enum OperatingSystem {
    case macOS
    case iOS
    case tvOS
    case watchOS
    case visionOS

    #if os(macOS)
    public static let current = macOS
    #elseif os(iOS)
    public static let current = iOS
    #elseif os(tvOS)
    public static let current = tvOS
    #elseif os(watchOS)
    public static let current = watchOS
    #elseif os(visionOS)
    public static let current = visionOS
    #else
    #error("Unsupported platform")
    #endif
}

public extension View {
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
    
    @ViewBuilder
    func ifNotOS(_ operatingSystems: OperatingSystem..., modifier: (Self) -> some View) -> some View {
        if operatingSystems.contains(OperatingSystem.current) {
            self
        } else {
            modifier(self)
        }
    }
}
