//
//  TranslatorView.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI
import Foundation

struct TranslatorView: View {
    
    @ObservedObject var viewModel = TranslatorViewModel()
    
    @State private var translatableText: String = String()
    @State private var translationEdit: String = String()
    @State private var languagesSupported: Array<Language> = []
    @State var selectedNavigation: String?
    @State var translationDirection: Bool = true
    // MARK - True = to, False = from
    
//    var body: some View {
//        VStack(spacing:10) {
//            NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
//                LanguageSelectorView()
//            } label: {
//                EmptyView()
//            }
//            languageSelectors
//            Text("welcome_screen_textField".localized)
//            userInput
//            TextEditor(text: $viewModel.translatedString)
//                .multilineTextAlignment(.center)
//                .padding()
//                .textFieldStyle(.roundedBorder)
//                .shadow(radius: 5)
//        }
//    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 10) {
                    NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                        LanguageSelectorView(toFromLanguage: translationDirection)
                    } label: {
                        EmptyView()
                    }
                    HStack {
                        Button {
                            translationDirection = true
                            didTapSelector()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                                    .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.1)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                Text(viewModel.languageA?.name ?? "languageSelectors_chooseLanguage".localized)
                            }
                        }
                        .buttonStyle(.borderless)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.accentColor)
                        Button {
                            translationDirection = false
                            didTapSelector()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                                    .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.1)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                Text(viewModel.languageB?.name ?? "languageSelectors_chooseLanguage".localized)
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
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                                .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.1)
                            Button(action: {
                                viewModel.defaultLanguageSelector(A: viewModel.languageA!, B: viewModel.languageB!)
                                viewModel.initiateTranslation(text: translatableText, sourceLanguage: viewModel.languageA!.translatorID, targetLanguage: viewModel.languageB!.translatorID)
                            }) {
                                Text("welcome_screen_translateButton".localized)
                            }
                            .buttonStyle(.borderless)
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
        .navigationBarTitle("")
        .navigationBarHidden(true)
        }
    
    
//    var languageSelectors: some View {
//
//            HStack(alignment:.center) {
//                Button(action: didTapSelector) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(.white)
//                            .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.2)
//                            .shadow(color: .gray, radius: 3, x: 0, y: 3)
//                        Text(languageA?.name ?? "languageSelectors_chooseLanguage".localized)
//                    }
//                }
//                .buttonStyle(.borderless)
//                Image(systemName: "arrow.right")
//                    .foregroundColor(.accentColor)
//                Button(action: didTapSelector) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(.white)
//                            .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.2)
//                            .shadow(color: .gray, radius: 3, x: 0, y: 3)
//                        Text(languageB?.name ?? "languageSelectors_chooseLanguage".localized)
//                    }
//                }
//                .buttonStyle(.borderless)
//            }
//            .padding()
//        }
//    }
//
//
//    var userInput: some View {
//        GeometryReader { geometry in
//            VStack(alignment: .center, content: {
//
//                TextEditor(text: $translatableText)
//                    .padding()
//                    .multilineTextAlignment(.center)
//                    .textFieldStyle(.roundedBorder)
//                    .shadow(radius: 5)
//
//                ZStack{
//                    RoundedRectangle(cornerRadius: 15)
//                        .fill(.blue)
//                        .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.2)
//                    Button(action: {
//                        defaultLanguageSelector(A: languageA!, B: languageB!)
//                        viewModel.initiateTranslation(text: translatableText, sourceLanguage: languageA!.translatorID, targetLanguage: languageB!.translatorID)
//                    }) {
//                        Text("welcome_screen_translateButton".localized)
//                    }
//                    .buttonStyle(.borderless)
//                }
//                .foregroundColor(Color.white)
//            })
//        }
//    }
//
    // MARK -- Checks to see if Language A and B are still empty values of type Language. Loads the translate function with default values, in this case English as Language A and Chinese (Simplified) as Language B.
    private func sameLanguageChecker() {
        if viewModel.languageA == viewModel.languageB {
            viewModel.translatedString = translatableText
        }
    }
    
    private func didTapSelector() {
        self.selectedNavigation = nil
        self.selectedNavigation = LanguageSelectorView.navigation
    }
    
    // TODO - Make picker default values reflect these default languages.
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        
        TranslatorView()
    }
}
