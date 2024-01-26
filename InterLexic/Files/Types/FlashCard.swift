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
    
    /// Sorts Flashcard objects by alphabetical order using both the sourceLanguage and targetLanguage properties. For example, 'Arabic English'  comes before 'Arabic French'.
    /// - Parameters:
    ///   - lhs: <#lhs description#>
    ///   - rhs: <#rhs description#>
    /// - Returns: <#description#>
    static func < (lhs: FlashCard, rhs: FlashCard) -> Bool {
        (lhs.sourceLanguage.name + lhs.targetLanguage.name) < (rhs.sourceLanguage.name + rhs.targetLanguage.name)
    }
}

