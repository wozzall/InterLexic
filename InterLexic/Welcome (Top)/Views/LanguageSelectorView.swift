//
//  LanguageSelector.swift
//  InterLexic
//
//  Created by George Worrall on 29/06/2022.
//

import SwiftUI

struct LanguageSelectorView: View {
    
    @EnvironmentObject var networkMonitor: Monitor
    @Environment(\.presentationMode) var presentationMode
    
    //    @EnvironmentObject var supportedLanguages: TranslatorLanguages
    
    @ObservedObject var manager: TranslationManager
    
    @Binding var languageA: Language
    @Binding var languageB: Language
    @Binding var toFromDirection: Bool
    
    @State var searchQuery = ""
    @State var filteredLanguages: Array<Language>?
    
    var body: some View {
        List{
            ForEach(Array(Set(filteredLanguages ?? manager.supportedLanguages).sorted())) { language in
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
        .overlay(
            ProgressView("ProgressView_Loading".localized)
                .opacity(manager.isLoading ? 1 : 0)
        )
        .navigationTitle("languageSelectors_chooseLanguage".localized)
        .onAppear {
            DispatchQueue.main.async {
                manager.fetchLanguage()
            }
        }
        .onDisappear(perform: testLanguageSelection)
        .alert(isPresented: $manager.isShowingAlert) {
            Alert(title: Text("TMerror_error".localized), message: Text("TMError_fetchLanguages".localized), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $manager.isShowingAlert) {
            Alert(title: Text("NetworkError_Error".localized), message: Text("NetworkError_NoConnection".localized), dismissButton: .destructive(Text("Ok!"), action: {
                presentationMode.wrappedValue.dismiss()
            })
            )}
        
        
    }
    
    func didTapLanguage(tapped language: Language, direction: Bool) {
        changeLanguages(toFromDirection: direction, in: language)
    }
    //MARK -
    
    private func testLanguageSelection() {
        print(languageA)
        print(languageB)
        print(manager.supportedLanguages)
        toFromDirection = false
    }
    //MARK - Prints out languages selected for testing ease-of-viewing.
    
    
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
            filteredLanguages = Array(Set(manager.supportedLanguages))
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
