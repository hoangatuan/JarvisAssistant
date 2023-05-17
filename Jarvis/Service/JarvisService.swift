//
//  JarvisService.swift
//  Jarvis
//
//  Created by Tuan Hoang on 16/05/2023.
//

import Foundation
import OpenAI

final class JarvisService: OpenAIProtocol {
    private let openAI: OpenAIProtocol

    init(openAI: OpenAIProtocol) {
        self.openAI = openAI
    }

    func completions(query: CompletionsQuery, completion: @escaping (Result<CompletionsResult, Error>) -> Void) {
        openAI.completions(query: query, completion: completion)
    }

    func completionsStream(query: CompletionsQuery, onResult: @escaping (Result<CompletionsResult, Error>) -> Void, completion: ((Error?) -> Void)?) {
        openAI.completionsStream(query: query, onResult: onResult, completion: completion)
    }

    func images(query: ImagesQuery, completion: @escaping (Result<ImagesResult, Error>) -> Void) {
        openAI.images(query: query, completion: completion)
    }

    public func embeddings(query: EmbeddingsQuery, completion: @escaping (Result<EmbeddingsResult, Error>) -> Void) {
        openAI.embeddings(query: query, completion: completion)
    }

    public func chats(query: ChatQuery, completion: @escaping (Result<ChatResult, Error>) -> Void) {
        openAI.chats(query: query, completion: completion)
    }

    public func chatsStream(query: ChatQuery, onResult: @escaping (Result<ChatStreamResult, Error>) -> Void, completion: ((Error?) -> Void)?) {
        openAI.chatsStream(query: query, onResult: onResult, completion: completion)
    }

    public func edits(query: EditsQuery, completion: @escaping (Result<EditsResult, Error>) -> Void) {
        openAI.edits(query: query, completion: completion)
    }

    public func model(query: ModelQuery, completion: @escaping (Result<ModelResult, Error>) -> Void) {
        openAI.model(query: query, completion: completion)
    }

    public func models(completion: @escaping (Result<ModelsResult, Error>) -> Void) {
        openAI.models(completion: completion)
    }

    public func moderations(query: ModerationsQuery, completion: @escaping (Result<ModerationsResult, Error>) -> Void) {
        openAI.moderations(query: query, completion: completion)
    }

    public func audioTranscriptions(query: AudioTranscriptionQuery, completion: @escaping (Result<AudioTranscriptionResult, Error>) -> Void) {
        openAI.audioTranscriptions(query: query, completion: completion)
    }

    public func audioTranslations(query: AudioTranslationQuery, completion: @escaping (Result<AudioTranslationResult, Error>) -> Void) {
        openAI.audioTranslations(query: query, completion: completion)
    }
}

