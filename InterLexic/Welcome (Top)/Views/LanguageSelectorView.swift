//
//  LanguageSelector.swift
//  InterLexic
//
//  Created by George Worrall on 29/06/2022.
//

import SwiftUI

struct LanguageSelectorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var manager = TranslationManager()
    @ObservedObject var viewModel: TranslatorViewModel
        
    var body: some View {
            List {
                ForEach(manager.supportedLanguages) { language in
                    ZStack {
                        Button {
                            didTapLanguage(tapped: language, direction: viewModel.toFromDirection)
                        } label: {
                            Text(language.name)
                        }
                    }
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("languageSelectors_chooseLanguage".localized)
            .onAppear(perform: manager.fetchLanguage)
            .onDisappear(perform: testLanguageSelection)
            .opacity(manager.isLoading ? 0 : 1)
            ProgressView()
                .opacity(manager.isLoading ? 1 : 0)
        }
    
    func didTapLanguage(tapped language: Language, direction: Bool) {
        viewModel.changeLanguages(toFromDirection: direction, in: language)
    }
    private func testLanguageSelection() {
        print(viewModel.languageA ?? "Whoops!")
        print(viewModel.languageB ?? "Whoops!")
        viewModel.toFromDirection = false
        }
}


        
    

    
//struct LanguageSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        LanguageSelectorView(toFromLanguage: true, languageA: $viewModel.languageA, languageB: $viewModel.languageB)
//    }
//}
