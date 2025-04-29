//
//  TipJarController.swift
//  DeepDishApp
//
//  Created by Morten Bjerg Gregersen on 28/04/2025.
//

import Foundation
import RevenueCat

@Observable
class TipJarController {
    var packages: [Package]?
    var error: PublicError?
    var fetching = false
    var purchasing = false
    var purchaseError: Error?
    var showsThankYou = false

    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_uYhBUAIOwLalomlCkFhykXXuHSK")
        fetchPackages()
    }

    func fetchPackages() {
        fetching = true
        Purchases.shared.getOfferings { offerings, error in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages.sorted(using: KeyPathComparator(\.identifier))
            } else {
                self.error = error
            }
            self.fetching = false
        }
    }

    func purchasePackage(_ package: Package) {
        purchasing = true
        Task {
            do {
                let result = try await Purchases.shared.purchase(package: package)
                showsThankYou = !result.userCancelled
            } catch {
                purchaseError = error
            }
            purchasing = false
        }
    }
}
