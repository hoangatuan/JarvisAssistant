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
    var jarvisService: Factory<OpenAIProtocol> {
        self {
            JarvisService(
                openAI: OpenAI(apiToken: "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")
            )
        }
        .scope(.singleton)
    }
}
