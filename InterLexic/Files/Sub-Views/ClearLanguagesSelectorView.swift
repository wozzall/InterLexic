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
    @Binding var sourceLanguageState: SelectorState
    @Binding var targetLanguageState: SelectorState
    
    var body: some View {
        HStack{
            Button {
                languageA = didTapClear()
                sourceLanguageState = .notSelected
            } label: {
                Text("Clear")
            }
            Button {
                languageB = didTapClear()
                targetLanguageState = .notSelected
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
