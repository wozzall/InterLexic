//
//  ExtensionArray.swift
//  InterLexic
//
//  Created by George Worrall on 11/07/2022.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
    
    func remove(at id: UUID) {
        
    }
}
