//
//  Bundle+Core.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 17/02/2025.
//

import Foundation

public extension Bundle {
    static var core: Bundle {
        Bundle(for: ScheduleController.self)
    }
}
