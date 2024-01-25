//
//  ExtensionCharacter.swift
//  InterLexic
//
//  Created by George Worrall on 25/01/2024.
//

import Foundation

extension Character {
    
    func convertToUpperCase() -> Character {
        if(self.isUppercase){
            return self
        }
        return Character(self.uppercased())
    }
}
