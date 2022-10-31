//
//  FlashCardDeck.swift
//  InterLexic
//
//  Created by George Worrall on 09/08/2022.
//

import Foundation

struct FlashCardDeck: Identifiable, Hashable, Codable, Comparable {
    
    var id: UUID
    
    var name: String
    var sourceLanguage: String
    var targetLanguage: String
    
    var flashCards: Array<FlashCard>
    
    
    
    static func < (lhs: FlashCardDeck, rhs: FlashCardDeck) -> Bool {
        (lhs.sourceLanguage + lhs.targetLanguage) < (rhs.sourceLanguage + rhs.targetLanguage)
    }
}
    
