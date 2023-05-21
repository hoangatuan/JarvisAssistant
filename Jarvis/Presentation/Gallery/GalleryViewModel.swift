//
//  GalleryViewModel.swift
//  Jarvis
//
//  Created by Tuan Hoang on 21/05/2023.
//

import Foundation
import OpenAI
import Factory
import SwiftUI

enum RequestImageSize: String {
    case x256 = "256x256"
    case x512 = "512x512"
    case x1024 = "1024x1024"
}

final class GalleryViewModel: ObservableObject {

    @Published
    var conversations: [GenericConversation<ImagesResult>] = []

    @Injected(\.jarvisService) private var jarvisService

    @MainActor
    func generateImages(prompt: String, size: RequestImageSize = .x512) async {
        do {
            conversations.append(.init(
                question: .init(content: prompt),
                answer: .init(status: .loading)
            ))

            let answer = try await jarvisService.images(
                query: .init(prompt: prompt, n: 1, size: size.rawValue)
            )

            conversations.last?.answer = .init(status: .success(answer: answer))
            objectWillChange.send()
        } catch {
            conversations.last?.answer = .init(status: .error)
        }
    }
}
