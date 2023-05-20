//
//  HomeViewModel.swift
//  Jarvis
//
//  Created by Tuan Hoang on 20/05/2023.
//

import SwiftUI
import Factory

struct Conversation: Identifiable, Hashable {
    var id = UUID().uuidString

    let isLoading: Bool
    let content: String
    let isBot: Bool

    init(isLoading: Bool = false, content: String = "", isBot: Bool) {
        self.isLoading = isLoading
        self.content = content
        self.isBot = isBot
    }
}


final class HomeViewModel: ObservableObject {

    @Injected(\.jarvisService) private var jarvisService

    @Published
    var conversations: [Conversation] = []

    @MainActor
    func chat(question: String) async {
        do {
            conversations.append(.init(content: question, isBot: false))
            conversations.append(.init(isLoading: true, isBot: false))
            let answerResult = try await jarvisService.chats(
                query: .init(model: .gpt3_5Turbo, messages: [.init(role: .user, content: question)], maxTokens: 1000)
            )
            let answer = answerResult.choices.first?.message.content ?? ""
            conversations.removeLast()
            conversations.append(.init(content: answer, isBot: true))
        } catch {
            conversations.removeLast()
            conversations.append(.init(content: "An error occurs. Please ask again", isBot: true))
        }
    }
}
