//
//  TranslatorView.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI
import Foundation

private enum Field: Int, CaseIterable {
    case sourceText, targetText
}

struct TranslatorView: View {
    
    @EnvironmentObject var supportedLanguages: TranslatorLanguages
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    
    @ObservedObject var manager = TranslationManager()
    @ObservedObject var viewModel = TranslatorViewModel()
    
    @State private var translatableText: String = String()
    var textEditorPlaceHolder: String = "Type text to translate here"
    @State private var translationEdit: String = String()
    @State private var languagesSupported: Array<Language> = []
    @State var selectedNavigation: String?
    
    @State var languageA: Language
    @State var languageB: Language
    
    @State var sameLanguage: Bool = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                                .fill(.blue)
                            //
                                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                            if languageA.name == "" {
                                Text("languageSelectors_chooseLanguage".localized)
                                
                            }
                            else {
                                Text(languageA.name)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    Image(systemName: "arrow.right")
                        .foregroundColor(.accentColor)
                    Button {
                        viewModel.setDirection(direction: true)
                        didTapSelector()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                            if languageB.name == "" {
                                Text("languageSelectors_chooseLanguage".localized)
                            }
                            else {
                                Text(languageB.name)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.top, 30)
                .buttonStyle(.borderless)
                
                ZStack{
                    VStack{
                        TextEditor(text: $translatableText)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .textFieldStyle(.roundedBorder)
                            .shadow(radius: 5)
                            .focused($focusedField, equals: .sourceText)
                    }
                    if translatableText.isEmpty {
                        VStack{
                            HStack{
                                Text(textEditorPlaceHolder)
                                    .padding(.top, 10)
                                    .padding(.horizontal)
                                    .opacity(0.4)
                                Spacer()
                            }
                            .padding()
                            Spacer()
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.33)
                
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                                .shadow(color: .gray, radius: 3, x: 0, y: 3)
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
                            
                            Button(action: {
                                saveButton()
                                
                            }) {
                                Text("welcome_screen_saveButton".localized)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.borderless)
                            
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    
                    TextEditor(text: $viewModel.translatedString)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .shadow(radius: 5)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: UIScreen.main.bounds.height * 0.33)
                        .focused($focusedField, equals: .targetText)


                }
                .navigationBarTitle("TabView_Translate".localized)
                .navigationBarHidden(true)
                .onAppear(perform: assignDefaultLanguages)
                .onTapGesture {
                    focusedField = nil
                }
        }
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
        
        if languageA.name.isEmpty && languageB.name.isEmpty {
            languageA = Language(name: "English", translatorID: "en", id: UUID())
            languageB = Language(name: "Chinese (Simplified)", translatorID: "zh-CN", id: UUID())
        }
        viewModel.toFromDirection = false
    }
    
    private func saveButton() {
        flashCardStorage.add(FlashCard(sourceLanguage: languageA.name, sourceString: translatableText, targetLanguage: languageB.name, targetString: viewModel.translatedString, id: UUID()))
        
        print(flashCardStorage.flashCards)
    }
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        
        TranslatorView(languageA: Language(name: "", translatorID: "", id: UUID()), languageB: Language(name: "", translatorID: "", id: UUID()))
    }
}
