//
//  TranslatorView.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI
import Foundation
import ToastSwiftUI

private enum Field: Int, CaseIterable {
    case sourceText, targetText
}

struct TranslatorView: View {
    
    
    @EnvironmentObject var networkMonitor: Monitor
    @EnvironmentObject var translatorLanguages: SupportedLanguages
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    
    @ObservedObject var manager = TranslationManager()
    @ObservedObject var viewModel = TranslatorViewModel()
    
    @State private var translatableText: String = String()
    let textEditorPlaceHolder: String = "Type text to translate here"
    @State private var translationEdit: String = String()
    @State private var languagesSupported: Array<Language> = []
    @State var selectedNavigation: String?
    
    @State var languageA: Language
    @State var languageB: Language
    
    @State var sameLanguage: Bool = false
    @State var tappedSave: Bool = false
    @State var disabledSave: Bool = true
    @State var showAlert: Bool = false
    
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
                            Color.offWhite
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                            if languageA.name == "" {
                                Text("languageSelectors_chooseLanguage".localized)
                                    .padding()
                            }
                            else {
                                Text(languageA.name)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    Image(systemName: "arrow.right")
                        .foregroundColor(.accentColor)
                    Button {
                        viewModel.setDirection(direction: true)
                        didTapSelector()
                    } label: {
                        ZStack {
                            Color.offWhite
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                            if languageB.name == "" {
                                Text("languageSelectors_chooseLanguage".localized)
                                    .padding()
                            }
                            else {
                                Text(languageB.name)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .foregroundColor(.blue)
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
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
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
                .frame(height: UIScreen.main.bounds.height * 0.3)
                
                HStack(spacing: 35){
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.blue)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                        Button(action: {
                            didTapTranslate()
                        }) {
                            Text("welcome_screen_translateButton".localized)
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    ZStack{
                        if disabledSave {
                            Color.offWhite
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .opacity(0.6)
                            
                            Button(action: {
                                saveButton()
                            }) {
                                Image(systemName: "star.fill")
                                    .opacity(0.6)
                            }
                            .buttonStyle(.borderless)
                            .disabled(disabledSave)
                        }
                        else {
                            Color.yellow
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                            
                            Button(action: {
                                saveButton()
                                self.disabledSave = true
                            }) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                
                TextEditor(text: $viewModel.translatedString)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                    .focused($focusedField, equals: .targetText)
                    .toast(isPresenting: $tappedSave, message: "Translation saved!")
                
                HStack {
                    Spacer()
                    Image("color-short")
                        .padding(.bottom)
                        .padding(.trailing)
                }
                
                
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
            languageA = translatorLanguages.languages.first(where: { $0.name == "English"})!
            languageB = translatorLanguages.languages.first(where: { $0.name == "Chinese (Simplified)"})!
        }
        viewModel.toFromDirection = false
    }

    
    private func didTapTranslate() {
        viewModel.defaultLanguageSelector(A: languageA, B: languageB)
        viewModel.initiateTranslation(text: translatableText, sourceLanguage: languageA.translatorID, targetLanguage: languageB.translatorID, sameLanguage: sameLanguage)
        self.disabledSave = false
        self.focusedField = nil
        self.tappedSave = false
    }
    
    private func saveButton() {
        if tappedSave != true {
            let newFlashCard = FlashCard(sourceLanguage: languageA.name, sourceString: translatableText, targetLanguage: languageB.name, targetString: viewModel.translatedString, id: UUID())
            flashCardStorage.add(newFlashCard)
            tappedSave = true
            flashCardStorage.flashCardDecks = flashCardStorage.sortIntoDecks()
            print(flashCardStorage.flashCardDecks)
        }
        else {
            return
        }
    }
}

//struct TranslatorView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        TranslatorView(languageA: Language(name: "", translatorID: "", id: UUID()), languageB: Language(name: "", translatorID: "", id: UUID()))
//    }
//}
