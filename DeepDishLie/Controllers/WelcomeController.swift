//
//  WelcomeController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

class WelcomeController: ObservableObject {
    @AppStorage("has-seen-welcome4") var hasSeenWelcome = false
    @Published var isShowingWelcome = false
}
