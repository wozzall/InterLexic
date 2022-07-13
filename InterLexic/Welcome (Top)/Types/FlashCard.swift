//
//  FlashCard.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import Foundation

struct FlashCard: Identifiable, Hashable, Codable {
    
    var sourceLanguage: String
    var sourceString: String
    var targetLanguage: String
    var targetString: String
    
    var id: UUID

    
}

