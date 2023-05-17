//
//  ContentView.swift
//  Jarvis
//
//  Created by Tuan Hoang on 15/05/2023.
//

import SwiftUI
import Factory

struct ContentView: View {

    @Injected(\.jarvisService) private var jarvisService

    @State
    var text: String = "Hello world"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(text)
        }
        .padding()
        .task {
            do {
                let result = try await jarvisService.chats(query: .init(model: .gpt3_5Turbo, messages: [.init(role: .user, content: "What's your name?")], maxTokens: 200))
            } catch {

            }
        }
    }

}

