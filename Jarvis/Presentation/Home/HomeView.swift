//
//  HomeView.swift
//  Jarvis
//
//  Created by Tuan Hoang on 15/05/2023.
//

import SwiftUI


struct HomeView: View {

    @State
    private var inputText = ""

    @State
    private var scrollToBottom: Bool = false

    @FocusState
    private var keyboardFocus: Bool

    @ObservedObject
    private var viewModel = HomeViewModel()

    var body: some View {
        
        VStack {
            conversationView()
            Spacer()
            inputView()
        }
        .padding()
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                scrollToBottom = true
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                scrollToBottom = true
            }
        }
        .onTapGesture {
            keyboardFocus = false
        }
    }

    @ViewBuilder
    private func buildConversationView(conversation: Conversation) -> some View {
        if conversation.isLoading {
            ProgressView()
        } else if conversation.isBot {
            HStack {
                Text(conversation.content)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)

                Spacer()
                Spacer()
                    .frame(width: 32)
            }
        } else {
            HStack {
                Spacer()
                    .frame(width: 32)
                Spacer()

                Text(conversation.content)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(16)
            }
        }
    }

    @ViewBuilder
    private func conversationView() -> some View {
        ScrollViewReader { scrollViewProxy in
            List {
                ForEach(viewModel.conversations) { conversation in
                    buildConversationView(conversation: conversation)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(.bottom, 16)
                }
            }
            .listStyle(.grouped)
            .onChange(of: scrollToBottom, perform: { _ in
                scrollViewProxy.scrollTo(viewModel.conversations.last, anchor: .bottom)
                scrollToBottom = false
            })
            .onChange(of: viewModel.conversations) { _ in
                scrollToBottom = true
            }
        }
    }

    private func inputView() -> some View {
        HStack {
            TextField("", text: $inputText)
                .placeholder(when: inputText.isEmpty) {
                    Text("Type a message...")
                        .foregroundColor(.gray)
                }
                .focused($keyboardFocus)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(24)

            Button {
                let query = inputText
                inputText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                Task {
                    await viewModel.chat(question: query)
                }
            } label: {
                Text("Send")
            }
            .disabled(inputText.isEmpty)
        }
    }
}
