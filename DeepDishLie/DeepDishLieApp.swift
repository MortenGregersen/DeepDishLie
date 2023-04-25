//
//  DeepDishLieApp.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

@main
struct DeepDishLieApp: App {
    @StateObject private var lieController = LieController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(lieController)
        }
    }
}
