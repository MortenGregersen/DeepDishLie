//
//  PlatformImage.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 13/04/2025.
//

#if os(macOS)
import AppKit
typealias PlatformImage = NSImage
#else
import UIKit
typealias PlatformImage = UIImage
#endif

extension PlatformImage {
    static func createFrom(name: String, bundle: Bundle) -> PlatformImage? {
        #if os(macOS)
        return bundle.image(forResource: name)
        #else
        return UIImage(named: name, in: bundle, with: nil)
        #endif
    }
}

import SwiftUI

extension Image {
    init(platformImage: PlatformImage) {
        #if canImport(AppKit)
        self.init(nsImage: platformImage)
        #else
        self.init(uiImage: platformImage)
        #endif
    }
}
