//
//  SpeakerImage.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 13/04/2025.
//

import SwiftUI

public struct SpeakerImage: View {
    private let speaker: Speaker

    public init(speaker: Speaker) {
        self.speaker = speaker
    }

    public var body: some View {
        if let image = PlatformImage.createFrom(name: speaker.image, bundle: .core) {
            Image(platformImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if let fallbackImageUrl = speaker.fallbackImageUrl {
            CachingAsyncImage(url: fallbackImageUrl)
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    SpeakerImage(speaker: .init(name: "", image: "michael_flarup", about: nil, fallbackImageUrl: nil, links: nil, isDanish: true))
    SpeakerImage(speaker: .init(name: "", image: "tim_cook", about: nil, fallbackImageUrl: URL(string: "https://picsum.photos/200")!, links: nil, isDanish: true))
}
