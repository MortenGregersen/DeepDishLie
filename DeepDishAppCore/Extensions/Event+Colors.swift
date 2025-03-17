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
            .init(uiColor: UIColor.lightText)
        } else {
            .accentColor
        }
    }

    var titleTextColor: Color {
        if isHappeningNow {
            .init(uiColor: UIColor.systemBackground)
        } else {
            toBeDetermined ? .secondary : .primary
        }
    }

    var subtitleTextColor: Color {
        if isHappeningNow {
            .init(uiColor: UIColor.systemBackground)
        } else {
            .secondary
        }
    }
}
