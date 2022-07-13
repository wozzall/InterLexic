//
//  TranslatorView.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI
import Foundation

struct TranslatorView: View {
    
    @EnvironmentObject var favorites: Favorites
    
    @ObservedObject var manager = TranslationManager()
    @ObservedObject var viewModel = TranslatorViewModel()
        
    @State private var translatableText: String = String()
    @State private var translationEdit: String = String()
    @State private var languagesSupported: Array<Language> = []
    @State var selectedNavigation: String?
    
    @State var languageA: Language
    @State var languageB: Language
    
    @State var sameLanguage: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 10) {
                    NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                        LanguageSelectorView(manager: manager, languageA: $languageA, languageB: $languageB, toFromDirection: $viewModel.toFromDirection)
                    } label: {
                        EmptyView()
                    }
                    HStack {
                        Button {
                            viewModel.setDirection(direction: false)
                            didTapSelector()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                                    .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.1)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                if languageA.name == "" {
                                    Text("languageSelectors_chooseLanguage".localized)
                                }
                                else {
                                    Text(languageA.name)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .buttonStyle(.borderless)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.accentColor)
                        Button {
                            viewModel.setDirection(direction: true)
                            didTapSelector()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                                    .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.1)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                if languageB.name == "" {
                                    Text("languageSelectors_chooseLanguage".localized)
                                }
                                else {
                                    Text(languageB.name)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .buttonStyle(.borderless)
                    .padding()
                    Text("welcome_screen_textField".localized)
                    TextEditor(text: $translatableText)
                        .padding()
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .shadow(radius: 5)
                    HStack(spacing: 15){
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.blue)
                            .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.1)
                        Button(action: {
                            viewModel.defaultLanguageSelector(A: languageA, B: languageB)
                            viewModel.initiateTranslation(text: translatableText, sourceLanguage: languageA.translatorID, targetLanguage: languageB.translatorID, sameLanguage: sameLanguage)
                        
                        }) {
                            Text("welcome_screen_translateButton".localized)
                        }
                        .buttonStyle(.borderless)
                    
                    }
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white)
                                .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.1)
                                
                                
                            Button(action: {
                                saveButton()
                                
                            }) {
                                Text("welcome_screen_saveButton".localized)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.borderless)
                        
                        }
                    }
                    .foregroundColor(Color.white)
                    TextEditor(text: $viewModel.translatedString)
                        .multilineTextAlignment(.center)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .shadow(radius: 5)
                }
            }
        }
        .onAppear{
            assignDefaultLanguages();
            manager.fetchLanguage()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }

    private func sameLanguageChecker() -> Bool {
        // MARK -- Checks to see if Language A and B are still empty values of type Language. Loads the translate function with default values, in this case English as Language A and Chinese (Simplified) as Language B.
        if languageA == languageB {
            return true
        }
            return false
    }
    
    private func didTapSelector() {
        self.selectedNavigation = nil
        self.selectedNavigation = LanguageSelectorView.navigation
    }
    
    private func assignDefaultLanguages() {
        
        if languageA.name == "" || languageB.name == "" {
            languageA = Language(name: "English", translatorID: "en", id: UUID())
            languageB = Language(name: "Chinese (Simplified)", translatorID: "zh-CN", id: UUID())
        }
        viewModel.toFromDirection = false
    }
    
    private func saveButton() {
        favorites.add(FlashCard(sourceLanguage: languageA.name, sourceString: translatableText, targetLanguage: languageB.name, targetString: viewModel.translatedString, id: UUID()))
        
        print(favorites.flashCards)
    }
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        
        TranslatorView(languageA: Language(name: "", translatorID: "", id: UUID()), languageB: Language(name: "", translatorID: "", id: UUID()))
    }
}
