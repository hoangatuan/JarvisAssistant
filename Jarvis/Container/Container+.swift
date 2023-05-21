//
//  Container+.swift
//  Jarvis
//
//  Created by Tuan Hoang on 17/05/2023.
//

import Foundation
import OpenAI
import Factory

extension Container {

    /// Get your token here: https://platform.openai.com/account/api-keys
    var jarvisService: Factory<OpenAIProtocol> {
        self {
            JarvisService(
                openAI: OpenAI(apiToken: "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")
            )
        }
        .scope(.singleton)
    }
}
