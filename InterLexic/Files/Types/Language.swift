//
//  Language.swift
//  InterLexic
//
//  Created by George Worrall on 26/06/2022.
//

import Foundation
import SwiftUI

struct Language: Identifiable, Hashable, Comparable, Codable {
    
    var name: String
    var translatorID: String
    var id = UUID()
    
    /// Sorts Language alphabetically by name.
    /// - Parameters:
    ///   - lhs: <#lhs description#>
    ///   - rhs: <#rhs description#>
    /// - Returns: <#description#>
    static func < (lhs: Language, rhs: Language) -> Bool {
        lhs.name < rhs.name
    }
}


