//
//  ExpandingTextEditorView.swift
//  InterLexic
//
//  Created by George Worrall on 29/10/2023.
//

import SwiftUI

struct ExpandingTextEditorView: View {
    @State private var text: String
    
    let placeholder = "Enter Text Here"
    
    init() {
        text = String()
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .topLeading) {
                    Color.gray
                        .opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(text)
                        .padding()
                        .opacity(!text.isEmpty ? 1 : 0)
                    TextEditor(text: $text)
                        .frame(minHeight: 100, alignment: .leading)
                        .cornerRadius(15)
                        .padding(.horizontal)

                        .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
                        .textSelection(.enabled)

                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

#Preview {
    ExpandingTextEditorView()
}
