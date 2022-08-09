//
//  LanguageSelector.swift
//  InterLexic
//
//  Created by George Worrall on 29/06/2022.
//

import SwiftUI

struct LanguageSelectorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var supportedLanguages: TranslatorLanguages
    
    @ObservedObject var manager: TranslationManager
        
    @Binding var languageA: Language
    @Binding var languageB: Language
    @Binding var toFromDirection: Bool
    
    @State var searchQuery = ""
    @State var filteredLanguages: Array<Language>?
    
    var body: some View {
        List{
            ForEach(Array(Set(filteredLanguages ?? manager.supportedLanguages).sorted()), id: \.name) { language in
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
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery) { _ in
            filterLanguages()
        }
        .onSubmit(of: .search) {
            filterLanguages()
        }
        
        .navigationTitle("languageSelectors_chooseLanguage".localized)
        .onAppear(perform: manager.fetchLanguage)
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
    
    //MARK - This function sets which language selector receives the chosen value based on a boolean value. In this case, true is language B and false is language A.
    
    func filterLanguages() {
      if searchQuery.isEmpty {
        // 1
          filteredLanguages = manager.supportedLanguages
      } else {
        // 2
          filteredLanguages = manager.supportedLanguages.filter {
          $0.name
            .localizedCaseInsensitiveContains(searchQuery)
        }
      }
    }
    // MARK - Filters language based on the current search query. Along with .onChange and .onSubmit, the list of languages dynamically changes.
}


        
    

    
//struct LanguageSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        LanguageSelectorView(toFromLanguage: true, languageA: $viewModel.languageA, languageB: $viewModel.languageB)
//    }
//}
