//
//  TranslatorView.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI

struct TranslatorView: View {
    
    @ObservedObject var viewModel = TranslatorViewModel()
    
    @State var translatableText: String = String()
    @State var languageA = Language(name: String(), translatorID: String(), id: UUID())
    @State var languageB = Language(name: String(), translatorID: String(), id: UUID())
    @State var translationEdit: String = String()
    
    var languagesSupported: Array<Language>
    
    init() {
        
        self.languagesSupported = [
            Language(name: "languageSelectors_English".localized, translatorID: "en", id: UUID()),
            Language(name: "languageSelectors_ChineseSimp".localized, translatorID: "zh-CN", id: UUID())
        ]
    }
    
    var body: some View {
        VStack(spacing:10) {
            
            Text("languageSelectors_chooseLanguage".localized)
                .multilineTextAlignment(.center)
            
            languageSelectors
            
            Text("welcome_screen_textField".localized)
            
            userInput
            
            TextEditor(text: $viewModel.translatedString)
                .multilineTextAlignment(.center)
                .padding()
                .textFieldStyle(.roundedBorder)
                .shadow(radius: 5)
        }
    }
    
    var languageSelectors: some View {
        
        GeometryReader { geometry in
            HStack(alignment:.center) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.2)
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    Picker("languageSelectors_chooseLanguage".localized, selection: $languageA) {
                        
                        ForEach(languagesSupported, id: \.self) { language in
                            Text(language.name)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .buttonStyle(.borderless)
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.accentColor)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.2)
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    Picker("languageSelectors_chooseLanguage".localized, selection: $languageB) {
                        
                        ForEach(languagesSupported, id: \.self) { language in
                            Text(language.name)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .padding()
        }
    }
    
    var userInput: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, content: {
                
                TextEditor(text: $translatableText)
                    .padding()
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .shadow(radius: 5)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.blue)
                        .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.2)
                    Button(action: {
                        
                        defaultLanguageSelector(A: languageA, B: languageB)
                        viewModel.initiateTranslation(text: translatableText, sourceLanguage: languageA.translatorID, targetLanguage: languageB.translatorID)
                    }) {
                        Text("welcome_screen_translateButton".localized)
                    }
                    .buttonStyle(.borderless)
                }
                .foregroundColor(Color.white)
            })
        }
    }
    
    // MARK -- Checks to see if Language A and B are still empty values of type Language. Loads the translate function with default values, in this case English as Language A and Chinese (Simplified) as Language B.
    
    func defaultLanguageSelector(A: Language, B: Language) {
        if A.name == "" {
            languageA = Language(name: "languageSelectors_English".localized, translatorID: "en", id: UUID())
            if B.name == "" {
                languageB = Language(name: "languageSelectors_ChineseSimp".localized, translatorID: "zh-CN", id: UUID())
                return
            }
        }
        return
    }
    // TODO - Make picker default values reflect these default languages.
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        
        TranslatorView()
    }
}
