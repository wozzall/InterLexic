//
//  FlashCard.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import Foundation

struct FlashCard: Identifiable, Hashable, Codable, Comparable, Equatable {
    
    var sourceLanguage: String
    var sourceString: String
    var targetLanguage: String
    var targetString: String
    
    
    var id: UUID
    
    static func < (lhs: FlashCard, rhs: FlashCard) -> Bool {
        (lhs.sourceLanguage + lhs.targetLanguage) < (rhs.sourceLanguage + rhs.targetLanguage)
    }
}

