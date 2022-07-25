//
//  Language.swift
//  InterLexic
//
//  Created by George Worrall on 26/06/2022.
//

import Foundation

struct Language: Identifiable, Hashable, Comparable {
    
    var name: String
    var translatorID: String
    var id: UUID
    
    static func < (lhs: Language, rhs: Language) -> Bool {
        lhs.name < rhs.name
    }
}


