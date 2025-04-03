//
//  MacConfettiManager.swift
//  DeepDishApp
//
//  Created by Morten Bjerg Gregersen on 02/04/2025.
//

#if os(macOS)
import AppKit
import ConfettiSwiftUI
import SwiftUI

class MacConfettiManager {
    private var confettiWindows: [NSWindow] = []

    func showConfettiOnAllScreens(trigger: Binding<Bool>) {
        hideConfetti()
        for screen in NSScreen.screens {
            let confettiWindow = createConfettiWindow(for: screen, trigger: trigger)
            confettiWindows.append(confettiWindow)
            confettiWindow.orderFront(nil)
        }
    }

    func hideConfetti() {
        confettiWindows.forEach { $0.close() }
        confettiWindows.removeAll()
    }

    private func createConfettiWindow(for screen: NSScreen, trigger: Binding<Bool>) -> NSWindow {
        let window = NSWindow(
            contentRect: .init(origin: .zero, size: screen.frame.size),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        window.isReleasedWhenClosed = false
        window.level = .screenSaver
        window.isOpaque = false
        window.backgroundColor = .clear
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.contentView = NSHostingView(rootView: ConfettiCannon(
            trigger: trigger,
            num: 10,
            confettis: [.text("🍕")],
            confettiSize: 100,
            rainHeight: 1200,
            fadesOut: true,
            openingAngle: .degrees(180),
            closingAngle: .degrees(0),
            radius: screen.frame.width/3,
            repetitionInterval: 1
        )
        .frame(width: screen.frame.width, height: screen.frame.height)
        .offset(y: -screen.frame.height/2))
        return window
    }
}
#endif
