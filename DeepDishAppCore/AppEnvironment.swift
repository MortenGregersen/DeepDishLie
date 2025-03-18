//
//  Environment.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import Foundation

public enum AppEnvironment {
    public static let inDemoMode = UserDefaults.standard.bool(forKey: "Demo")
}
