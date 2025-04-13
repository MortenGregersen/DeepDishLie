//
//  Bundle+Core.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 17/02/2025.
//

import Foundation

public extension Bundle {
    static var widgetCore: Bundle {
        Bundle(for: Dummy.self)
    }

    private class Dummy {}
}
