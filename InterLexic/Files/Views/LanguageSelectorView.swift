//
//  LanguageSelector.swift
//  InterLexic
//
//  Created by George Worrall on 29/06/2022.
//

import SwiftUI
import Foundation

struct LanguageSelectorView: View {
    
    @EnvironmentObject var networkMonitor: Monitor
    @EnvironmentObject var manager: TranslationManager
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var languageA: Language
    @Binding var languageB: Language
    @Binding var toFromDirection: Bool
    
    @State var hasLoaded: Bool = false
    @State var searchQuery = ""
    @State var filteredLanguages: Array<Language>?
    @Binding var languageDetectionRequired: Bool
    @State var hideDetectButton: Bool
    
    var alphabetList: Array<Character> = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var languageList: Array<Language> {
        Array(Set(filteredLanguages ?? manager.supportedLanguages)).sorted()
    }
    
    var body: some View {
        ScrollViewReader { scrollProxy in
//            ZStack {
            List {
                if !hideDetectButton {
                    Section{
                        Button {
                            didTapDetect()
                            languageA = Language(name: "Detecting...", translatorID: "")
                        } label: {
                            Text("languageSelectorView_detect".localized)
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.blue)
                    }
                }
                    ForEach(alphabetList, id: \.self) { letter in
                        Section(header: Text(String(letter))) {
                            ForEach(languageList.filter {$0.name.first == letter }) { language in
                                if !languageList.isEmpty{
                                    Button {
                                        didTapLanguage(tapped: language, direction: toFromDirection)
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Text(language.name)
                                    }
                                }
                            }
                        }
                    }
                }
//                .padding(.trailing)
                .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: searchQuery) { _ in
                    filterLanguages()
                }
                .onSubmit(of: .search) {
                    filterLanguages()
                }
                .overlay(
                    ProgressView("progressView_loading".localized)
                        .opacity(manager.isLoading ? 1 : 0)
                )
                .overlay(alignment: .trailing) {
                    VStack(spacing: 1) {
                        ForEach(alphabetList, id: \.self) { letter in
                            Button {
                                print("letter = \(letter)")
                                //need to figure out if there is a name in this section before I allow scrollto or it will crash
                                if languageList.first(where: { $0.name.first == letter }) != nil {
                                    withAnimation {
                                        scrollProxy.scrollTo(letter, anchor: .top)
                                    }
                                }
                            } label: {
                                Text(String(letter))
                                    .font(.system(size: 15))
                                    .padding(.trailing, 9)
                            }
                            
                        }
                    }
                    .padding(.leading)
                }
            
                .navigationTitle("languageSelectorView_chooseLanguage".localized)
                .onDisappear(perform: testLanguageSelection)
                .alert(isPresented: $manager.isShowingAlert) {
                    Alert(title: Text("tMError_error".localized), message: Text("tMError_fetchLanguages".localized), dismissButton: .default(Text("tMerror_ok".localized)))
                }
                .alert(isPresented: $manager.isShowingAlert) {
                    Alert(title: Text("networkError_error".localized), message: Text("networkError_noConnection".localized), dismissButton: .destructive(Text("tMError_ok".localized), action: {
                        presentationMode.wrappedValue.dismiss()})
                    )}
//            }
//            .background(UIColor.secondarySystemGroupedBackground)
            
            
        }
    }
    
    private func didTapLanguage(tapped language: Language, direction: Bool) {
        changeLanguages(toFromDirection: direction, in: language)
    }
    //MARK -
    
    private func didTapDetect() {
        languageDetectionRequired = true
        presentationMode.wrappedValue.dismiss()
    }
    
    private func testLanguageSelection() {
        print(languageA)
        print(languageB)
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
            filteredLanguages = manager.supportedLanguages
        } else {
            // 2
            filteredLanguages = manager.supportedLanguages.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    // MARK - Filters language based on the current search query. Along with .onChange and .onSubmit, the list of languages dynamically changes.
    
//    func supportedLanguagesSetup() {
//        if !hasLoaded {
//            if self.translatorLanguages.languages.isEmpty {
//                for language in manager.supportedLanguages {
//                    self.translatorLanguages.add(language)
//                    self.translatorLanguages.languages.sort()
//                }
//            }
//            hasLoaded = true
//        }
//    }
}






//struct LanguageSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        LanguageSelectorView(toFromLanguage: true, languageA: $viewModel.languageA, languageB: $viewModel.languageB)
//    }
//}

//
