//
//  FlashCard.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import Foundation

struct FlashCard: Identifiable, Hashable, Codable, Comparable, Equatable {
    
    var sourceLanguage: Language
    var sourceString: String
    var targetLanguage: Language
    var targetString: String
    
    
    var id: UUID
    
    static func < (lhs: FlashCard, rhs: FlashCard) -> Bool {
        (lhs.sourceLanguage.name + lhs.targetLanguage.name) < (rhs.sourceLanguage.name + rhs.targetLanguage.name)
    }
}

