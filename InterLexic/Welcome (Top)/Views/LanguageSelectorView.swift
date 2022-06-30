//
//  LanguageSelector.swift
//  InterLexic
//
//  Created by George Worrall on 29/06/2022.
//

import SwiftUI

struct LanguageSelectorView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: TranslatorViewModel = TranslatorViewModel()
    @ObservedObject var manager = TranslationManager()
    @State var toFromLanguage: Bool
    
    var body: some View {
            List {
                ForEach(manager.supportedLanguages) { language in
                    ZStack {
                        Button {
                            didTapLanguage(tapped: language, direction: toFromLanguage)
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
        if toFromLanguage {
            viewModel.languageA = language
        }
        else {
            viewModel.languageB = language
        }
    }
    private func testLanguageSelection() {
        print(viewModel.languageA?.name ?? "none")
        print(viewModel.languageB?.name ?? "none")
        }
}


        
    

    
struct LanguageSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectorView(toFromLanguage: true)
    }
}
