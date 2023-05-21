//
//  GalleryView.swift
//  Jarvis
//
//  Created by Tuan Hoang on 21/05/2023.
//

import SwiftUI
import OpenAI

struct GalleryView: View {

    @State
    private var inputText = "Generate an image of HaNoi in the morning"

    @State
    private var scrollToBottom: Bool = false

    @FocusState
    private var keyboardFocus: Bool

    @ObservedObject
    private var viewModel = GalleryViewModel()

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
    private func buildConversationView(conversation: GenericConversation<ImagesResult>) -> some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 32)
                Spacer()

                Text(conversation.question.content)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(16)
            }

            switch conversation.answer.status {
            case .loading:
                HStack {
                    ProgressView()
                    Spacer()
                }
            case .error:
                HStack {
                    Text("An error occurs. Please ask again")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)

                    Spacer()
                    Spacer()
                        .frame(width: 32)
                }
            case .success(let answer):
                HStack {
                    AsyncImage(url: URL(string: answer.data[0].url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 256, height: 256)
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                }
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
//            .onChange(of: scrollToBottom, perform: { _ in
//                scrollViewProxy.scrollTo(viewModel.conversations.last, anchor: .bottom)
//                scrollToBottom = false
//            })
//            .onChange(of: viewModel.conversations.count) { _ in
//                scrollToBottom = true
//            }
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
                    await viewModel.generateImages(prompt: query)
                }
            } label: {
                Text("Send")
            }
            .disabled(inputText.isEmpty)
        }
    }
}
