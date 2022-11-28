//
//  Acknowledgement.swift
//  InterLexic
//
//  Created by George Worrall on 31/10/2022.
//

import Foundation
import SwiftUI

struct Acknowledgement: Identifiable, Comparable {
    
    var id: UUID
    
    var name: String
    var uRL: String
    var version: String?
    var disclaimer: String?
    var terms: String?
    var image: Image?
    
    static func < (lhs: Acknowledgement, rhs: Acknowledgement) -> Bool {
        (lhs.name) < (rhs.name)
    }
}

