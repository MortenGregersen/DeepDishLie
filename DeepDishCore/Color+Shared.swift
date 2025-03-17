//
//  Color+Shared.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import SwiftUI

public extension Color {
    static var accent: Color {
        Color("AccentColor", bundle: .core)
    }
    
    static var navigationBarBackground: Color {
        Color("NavigationBarBackground", bundle: .core)
    }
    
    static var splashBackground: Color {
        Color("SplashBackground", bundle: .core)
    }
}
