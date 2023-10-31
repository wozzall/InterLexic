//
//  addBorder.swift
//  InterLexic
//
//  Created by George Worrall on 31/10/2023.
//

import SwiftUI

struct AddBorder: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            }
    }
}
