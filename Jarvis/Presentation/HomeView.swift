//
//  HomeView.swift
//  Jarvis
//
//  Created by Tuan Hoang on 15/05/2023.
//

import SwiftUI
import Factory

struct HomeView: View {

    @State
    private var inputText = ""

    @ObservedObject
    private var viewModel = HomeViewModel()

    var body: some View {
        
        VStack {
            List {
                ForEach(viewModel.conversations) { conversation in
                    buildConversationView(conversation: conversation)
                }
            }
            Spacer()
            HStack {
                TextField("Enter your name", text: $inputText)
                Button {
                    Task {
                        await viewModel.chat(question: inputText)
                    }
                } label: {
                    Text("Tap here")
                }

            }
        }
        .padding()

    }

    @ViewBuilder
    func buildConversationView(conversation: Conversation) -> some View {
        if conversation.isLoading {
            EmptyView()
        } else if conversation.isBot {
            Text(conversation.content)
                .foregroundColor(.black)
//                .frame(width: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
        } else {
            Text(conversation.content)
                .foregroundColor(.white)
//                .frame(width: .infinity, alignment: .trailing)
                .padding()
                .background(Color.yellow)
        }
    }
}

struct Conversation: Identifiable {
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
                query: .init(model: .gpt3_5Turbo, messages: [.init(role: .user, content: question)], maxTokens: 200)
            )
            let answer = answerResult.choices.first?.message.content ?? ""
            conversations.removeLast()
            conversations.append(.init(content: answer, isBot: true))
        } catch {

        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
