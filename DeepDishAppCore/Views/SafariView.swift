//
//  SafariView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

#if os(iOS)
import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.preferredControlTintColor = UIColor.tintColor
        return viewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

extension URL: @retroactive Identifiable {
    public var id: URL { self }
}

#Preview {
    SafariView(url: URL(string: "https://appdab.app")!)
}
#endif
