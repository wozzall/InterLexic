//
//  LanguageSelector.swift
//  InterLexic
//
//  Created by George Worrall on 29/06/2022.
//

import SwiftUI

struct LanguageSelectorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var manager: TranslationManager
        
    @Binding var languageA: Language
    @Binding var languageB: Language
    @Binding var toFromDirection: Bool
    
    var body: some View {
        List{
            ForEach(manager.supportedLanguages) { language in
                ZStack {
                    Button {
                        didTapLanguage(tapped: language, direction: toFromDirection)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(language.name)
                    }
                }
            }
        }
        
        .navigationTitle("languageSelectors_chooseLanguage".localized)
//        .onAppear(perform: manager.fetchLanguage)
        .onDisappear(perform: testLanguageSelection)
        .opacity(manager.isLoading ? 0 : 1)
        ProgressView()
            .opacity(manager.isLoading ? 1 : 0)
    }
    
    func didTapLanguage(tapped language: Language, direction: Bool) {
        changeLanguages(toFromDirection: direction, in: language)
    }
    private func testLanguageSelection() {
        print(languageA)
        print(languageB)
        toFromDirection = false
        }
    
    func changeLanguages(toFromDirection: Bool, in language: Language) {
        if toFromDirection {
            languageB = language
        }
        else {
            languageA = language
        }
    }
}


        
    

    
//struct LanguageSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        LanguageSelectorView(toFromLanguage: true, languageA: $viewModel.languageA, languageB: $viewModel.languageB)
//    }
//}
