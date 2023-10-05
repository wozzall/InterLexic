//
//  TextEditorClearButton.swift
//  InterLexic
//
//  Created by George Worrall on 05/10/2023.
//

import Foundation
import SwiftUI

struct TextEditorClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                if !text.isEmpty {
                    Button(
                        action: { self.text = "" },
                        label: {
                            Image(systemName: "delete.left")
                                .foregroundColor(.red)
                        }
                            
                    )
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                }
            }
    }
}
