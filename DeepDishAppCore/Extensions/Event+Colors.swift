//
//  Event+Colors.swift
//  DeepDishAppCore
//
//  Created by Matt Heaney on 22/02/2025.
//

import DeepDishCore
import SwiftUI

public extension Event {
    var dateTextColor: Color {
        if isHappeningNow {
            #if os(iOS)
            .init(uiColor: UIColor.lightText)
            #else
            .white
            #endif
        } else {
            #if os(visionOS)
            OperatingSystem.current == .visionOS ? Color.accent.mix(with: .black, by: 0.35) : Color.accent
            #else
            .accent
            #endif
        }
    }

    var titleTextColor: Color {
        if isHappeningNow {
            #if os(iOS)
            .init(uiColor: UIColor.systemBackground)
            #else
            .black
            #endif
        } else {
            toBeDetermined ? .secondary : .primary
        }
    }

    var subtitleTextColor: Color {
        if isHappeningNow {
            #if os(iOS)
            .init(uiColor: UIColor.systemBackground)
            #else
            .white
            #endif
        } else {
            .secondary
        }
    }
}
