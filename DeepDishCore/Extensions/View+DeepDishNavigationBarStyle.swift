//
//  View+DeepDishNavigationBarStyle.swift
//  DeepDishCore
//
//  Created by Codex on 13/03/2026.
//

import SwiftUI

#if os(iOS)
import UIKit

private extension UINavigationBarAppearance {
    static func deepDishLeather(for traitCollection: UITraitCollection) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundEffect = nil
        appearance.backgroundColor = UIColor(Color.navigationBarBackground)
        appearance.shadowColor = UIColor(red: 0.62, green: 0.45, blue: 0.24, alpha: 0.35)
        if let leatherImage = UIImage(
            named: "NavigationLeather",
            in: .core,
            compatibleWith: traitCollection
        )?.resizableImage(withCapInsets: .zero, resizingMode: .tile) {
            appearance.backgroundImage = leatherImage
        }
        return appearance
    }
}

private struct DeepDishNavigationBarConfigurator: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DeepDishNavigationBarHostingController {
        DeepDishNavigationBarHostingController()
    }

    func updateUIViewController(_ uiViewController: DeepDishNavigationBarHostingController, context: Context) {
        uiViewController.applyAppearance()
    }
}

private final class DeepDishNavigationBarHostingController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForTraitChanges([UITraitUserInterfaceStyle.self], action: #selector(handleUserInterfaceStyleChange))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyAppearance()
    }

    @objc private func handleUserInterfaceStyleChange() {
        applyAppearance()
    }

    func applyAppearance() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        let appearance = UINavigationBarAppearance.deepDishLeather(for: traitCollection)
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
    }
}

private struct DeepDishNavigationBarStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DeepDishNavigationBarConfigurator().frame(width: 0, height: 0))
    }
}
#endif

public extension View {
    @ViewBuilder func deepDishNavigationBarStyle() -> some View {
        #if os(iOS)
        self.modifier(DeepDishNavigationBarStyleModifier())
        #else
        self
        #endif
    }
}
