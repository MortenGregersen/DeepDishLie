//
//  CachingAsyncImage.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 13/04/2025.
//

import SwiftUI

struct CachingAsyncImage: View {
    let url: URL?
    @State private var state = LoadingState.loading
    static let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
                .task { await loadImage() }
        case .loaded(let image):
            image
                .resizable()
        case .failed:
            Image(systemName: "exclamationmark.circle")
                .font(.title)
        case .empty:
            EmptyView()
        }
    }

    @MainActor private func loadImage() async {
        if let url {
            state = .loading
            try! await Task.sleep(for: .seconds(2))
            let data = try? await Self.urlSession.data(for: .init(url: url)).0
            if let image = createImage(from: data) {
                state = .loaded(image)
            } else {
                state = .failed
            }
        } else {
            state = .empty
        }
    }

    private func createImage(from data: Data?) -> Image? {
        guard let data else { return nil }
        #if canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        return Image(nsImage: nsImage)
        #else
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #endif
    }

    private enum LoadingState: Equatable {
        case loading
        case loaded(Image)
        case failed
        case empty
    }
}


#Preview {
    CachingAsyncImage(url: URL(string: "https://picsum.photos/200")!)
        .frame(width: 200, height: 200)
        .aspectRatio(contentMode: .fit)
}
