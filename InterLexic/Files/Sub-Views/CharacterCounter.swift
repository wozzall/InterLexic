//
//  CharacterCounter.swift
//  InterLexic
//
//  Created by George Worrall on 31/10/2023.
//

import SwiftUI

struct CharacterCounter: View {
    
    @Binding var charCount: Int
    let charLimit: Int
    var countEqual: Bool {
        if charCount == charLimit {
            return true
        }
        return false
    }
    
    var body: some View {
        Text("\(charCount) / \(charLimit)" )
            .foregroundColor(countEqual ? .red : .black.opacity(0.4))
    }
}

