//
//  Conversation.swift
//  Jarvis
//
//  Created by Tuan Hoang on 21/05/2023.
//

import Foundation

struct Question: Equatable {
    let content: String
}

class GenericConversation<T: Codable & Equatable>: Identifiable, Equatable {
    static func == (lhs: GenericConversation<T>, rhs: GenericConversation<T>) -> Bool {
        return lhs.question == rhs.question && lhs.answer == rhs.answer
    }

    let question: Question
    var answer: Answer<T>

    init(question: Question, answer: Answer<T>) {
        self.question = question
        self.answer = answer
    }
}

struct Answer<T: Codable & Equatable>: Equatable {

    enum Status: Codable, Equatable {
        case success(answer: T)
        case loading
        case error
    }

    let status: Status

    init(status: Status) {
        self.status = status
    }

    static func == (lhs: Answer<T>, rhs: Answer<T>) -> Bool {
        lhs.status == rhs.status
    }
}
