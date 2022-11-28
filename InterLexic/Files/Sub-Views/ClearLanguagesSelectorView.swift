//
//  ClearLanguagesSelectorView.swift
//  InterLexic
//
//  Created by George Worrall on 22/11/2022.
//

import SwiftUI

struct ClearLanguagesSelectorView: View {
    
    @Binding var languageA: Language
    @Binding var languageB: Language
    
    var body: some View {
        HStack{
            Button {
                languageA = didTapClear()
            } label: {
                Text("Clear")
            }
            Button {
                languageB = didTapClear()
            } label: {
                Text("Clear")
            }
        }
    }
    
    private func didTapClear() -> Language {
        let clearedLanguage = Language(name: "", translatorID: "")
        return clearedLanguage
    }
}

//struct ClearLanguagesSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClearLanguagesSelectorView()
//    }
//}
