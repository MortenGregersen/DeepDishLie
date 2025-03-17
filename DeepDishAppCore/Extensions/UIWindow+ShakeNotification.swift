//
//  UIWindow+ShakeNotification.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import UIKit

// Borrowed from Hacking with Swift:
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-shake-gestures

public extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
