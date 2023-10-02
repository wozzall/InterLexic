//
//  TranslatorView.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI
import Foundation
import AVFoundation
import NaturalLanguage
import ToastSwiftUI

private enum Field: Int, CaseIterable {
    case sourceText, targetText
}

struct TranslatorView: View {
    
    
    @EnvironmentObject var networkMonitor: Monitor
    @EnvironmentObject var manager: TranslationManager
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    
    @ObservedObject var viewModel = TranslatorViewModel()
    @ObservedObject var textToSpeech = TextToSpeech()
    @State var synthesizer = AVSpeechSynthesizer()
    
    
    @State private var translatableText: String = String()
    let textEditorPlaceHolder: String = "Type text here to detect language or to translate!"
    @State private var translationEdit: String = String()
    @State private var languagesSupported: Array<Language> = []
    @State var selectedNavigation: String?
    
    @State var languageA: Language = Language(name: "", translatorID: "")
    @State var languageB: Language = Language(name: "", translatorID: "")
    @State var detectedLanguage: Language?
    
    @State var sameLanguage: Bool = false
    @State var tappedSave: Bool = false
    @State var disabledSave: Bool = true
    @State var showAlert: Bool = false
    @State var languageDetectionRequired = true
    
    
    @FocusState private var focusedField: Field?
    
    init() {
        UITextView.appearance().textContainerInset =
        UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 12)
    }
    
    
    var body: some View {
        NavigationView{
            ScrollView {
                NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                    LanguageSelectorView(languageA: $languageA, languageB: $languageB, toFromDirection: $viewModel.toFromDirection, languageDetectionRequired: false)
                } label: {
                    EmptyView()
                }
                
                languageSelectorButtonsView
                
                if languageDetectionRequired {
                    textEditorWithDetectionView
                } else {
                    textEditorView
                }
                HStack(spacing: 35){
                    if !languagesAreSelected() {
                        translateButton
                    } else {
                        translateGreyedOutButton
                    }
                    if disabledSave {
                        disabledSaveButton
                    } else {
                        saveTranslationButton
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                
                receivedTranslationEditor
                
                HStack {
                    Spacer()
                    Image("color-regular")
                        .padding(.bottom)
                        .padding(.trailing)
                }
            }
            .navigationBarTitle("TabView_Translate".localized)
            .navigationBarHidden(true)
            .background(Color.offWhite.opacity(0.5))
            
            .onAppear {
                manager.fetchLanguages()
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }
        
    var languageSelectorButtonsView: some View {
        HStack {
            Button {
                viewModel.setDirection(direction: false)
                didTapSelector(isLanguageDetectionRequired: true)
            } label: {
                ZStack {
                    Color.offWhite
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black.opacity(0.5))
                                .opacity(0.3)
                        )
                    if languageA.name == "" {
                        Text("languageSelectorView_from".localized)
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
                didTapSelector(isLanguageDetectionRequired: false)
            } label: {
                ZStack {
                    Color.offWhite
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black.opacity(0.5))
                                .opacity(0.3)
                        )
                    if languageB.name == "" {
                        Text("languageSelectorView_to".localized)
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
    }
    
    var textEditorWithDetectionView: some View {
        ZStack {
            TextEditor(text: $translatableText)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .multilineTextAlignment(.leading)
                .lineSpacing(3)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1))
            
                .overlay(alignment: .topTrailing) {
                    if !translatableText.isEmpty{
                    Button {
                        translatableText = String()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.black.opacity(0.2))
                    }
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                    
                }
            }
                .overlay(alignment: .bottomTrailing) {
                    if textToSpeech.audioAvailable(inputString: translatableText, googleLanguageCode: languageA.translatorID){
                        Button {
                            textToSpeech.languageRecognizer.reset()
                            textToSpeech.synthesizeSpeech(inputMessage: translatableText)
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.blue.opacity(0.8))
                                .font(.title3)
                        }
                        .padding(.bottom, 8)
                        .padding(.trailing, 8)
                    } else {
                        Image(systemName: "speaker.slash.fill")
                            .foregroundColor(.gray.opacity(0.2))
                            .font(.title3)
                            .padding(.bottom, 8)
                            .padding(.trailing, 8)
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    if translatableText.isEmpty == false {
                        if detectedLanguage?.name != ""{
                            HStack(spacing: 0){
                                Text("\(detectedLanguage?.name ?? "".localized)")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        languageA = detectedLanguage ?? Language(name: "None Detected", translatorID: "", id: UUID())
                                        languageDetectionRequired = false
                                    }
                                    .padding(.trailing, 4)
                                Text("translatorView_detected".localized)
                                    .foregroundColor(.gray.opacity(0.8))
                                
                            }
                            .padding(.bottom)
                            .padding(.leading)
                        }
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .sourceText)
                .onChange(of: translatableText) { _ in
                    languageDetectionRequired = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                        manager.detectLanguage(forText: translatableText) { result in
                            for language in manager.supportedLanguages {
                                if manager.sourceLanguageCode == language.translatorID {
                                    detectedLanguage = language
                                }
                            }
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.3)
            if translatableText.isEmpty {
                VStack{
                    HStack{
                        Text(textEditorPlaceHolder)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .opacity(0.4)
                            .allowsHitTesting(false)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
            }
        }
        
        
        
    }
    
    var textEditorView: some View {
        ZStack {
            TextEditor(text: $translatableText)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .multilineTextAlignment(.leading)
                .lineSpacing(3)
            
                .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
            
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1))
                .overlay(alignment: .topTrailing) {
                    if !translatableText.isEmpty{
                    Button {
                        translatableText = String()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.black.opacity(0.2))
                    }
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                    
                }
            }

                .overlay(alignment: .bottomTrailing) {
                    if textToSpeech.audioAvailable(inputString: translatableText, googleLanguageCode: languageA.translatorID){
                        Button {
                            textToSpeech.languageRecognizer.reset()
                            textToSpeech.synthesizeSpeech(inputMessage: translatableText)
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.blue.opacity(0.8))
                                .font(.title3)
                        }
                        .padding(.bottom, 8)
                        .padding(.trailing, 8)
                    } else {
                        Image(systemName: "speaker.slash.fill")
                            .foregroundColor(.gray.opacity(0.2))
                            .font(.title3)
                            .padding(.bottom, 8)
                            .padding(.trailing, 8)
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .sourceText)
                .frame(height: UIScreen.main.bounds.height * 0.3)
            
            if translatableText.isEmpty {
                VStack{
                    HStack{
                        Text(textEditorPlaceHolder)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .opacity(0.4)
                            .allowsHitTesting(false)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
            }
        }
        
    }
    
    var translateButton: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.offWhite.opacity(0.6))
            
            Button(action: {
                didTapTranslate()
            }) {
                Text("translatorView_translateButton".localized)
            }
            .foregroundColor(.gray)
            .buttonStyle(.borderless)
            .disabled(true)
        }
    }
    
    var translateGreyedOutButton: some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.blue)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.black)
                        .opacity(0.4)
                )
            Button(action: {
                didTapTranslate()
            }) {
                Text("translatorView_translateButton".localized)
            }
            .buttonStyle(.borderless)
        }
    }
    
    var saveTranslationButton: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.yellow)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white)
                        .opacity(0.3)
                )
            Button(action: {
                saveButton()
                self.disabledSave = true
            }) {
                Text("translatorView_saveButton".localized)
                    .foregroundColor(.white)
            }
            .buttonStyle(.borderless)
        }
    }
    
    var disabledSaveButton: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.offWhite)
                .opacity(0.6)
            Button(action: {
                saveButton()
            }) {
                Text("translatorView_saveButton".localized)
                    .foregroundColor(.gray)
            }
            .buttonStyle(.borderless)
            .disabled(disabledSave)
        }
    }
    
    var receivedTranslationEditor: some View {
        TextEditor(text: $viewModel.translatedString)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .multilineTextAlignment(.leading)
            .lineSpacing(3)
            .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .overlay(alignment: .bottomTrailing) {
                if textToSpeech.audioAvailable(inputString: viewModel.translatedString, googleLanguageCode: languageB.translatorID){
                    Button {
                        textToSpeech.languageRecognizer.reset()
                        textToSpeech.synthesizeSpeech(inputMessage: viewModel.translatedString)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.blue.opacity(0.8))
                            .font(.title3)
                    }
                    .padding(.bottom, 8)
                    .padding(.trailing, 8)
                } else {
                    Image(systemName: "speaker.slash.fill")
                        .foregroundColor(.gray.opacity(0.2))
                        .font(.title3)
                        .padding(.bottom, 8)
                        .padding(.trailing, 8)
                }
            }
            .padding()
            .frame(height: UIScreen.main.bounds.height * 0.3)
            .focused($focusedField, equals: .targetText)
            .toast(isPresenting: $tappedSave, message: "translatorView_translationSaved".localized)
    }
    
    
    private func isDetectionRequired() {
        if languageA == detectedLanguage {
            languageDetectionRequired = false
        }
    }
    
    private func languagesAreSelected() -> Bool {
        if languageA.name == "" || languageB.name == "" {
            return false
        }
        return true
    }
    
    
    private func sameLanguageChecker() -> Bool {
        // MARK -- Checks to see if Language A and B are still empty values of type Language. Loads the translate function with default values, in this case English as Language A and Chinese (Simplified) as Language B.
        if languageA == languageB {
            return true
        }
        return false
    }
    
    private func didTapSelector(isLanguageDetectionRequired: Bool) {
        self.selectedNavigation = nil
        self.languageDetectionRequired = isLanguageDetectionRequired
        self.selectedNavigation = LanguageSelectorView.navigation
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
            let newFlashCard = FlashCard(sourceLanguage: languageA, sourceString: translatableText, targetLanguage: languageB, targetString: viewModel.translatedString, id: UUID())
            flashCardStorage.add(newFlashCard)
            tappedSave = true
            flashCardStorage.flashCardDecks = flashCardStorage.sortIntoDecks()
            print(flashCardStorage.flashCardDecks)
        }
        return
    }
}


//struct TranslatorView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        TranslatorView(languageA: Language(name: "", translatorID: "", id: UUID()), languageB: Language(name: "", translatorID: "", id: UUID()))
//    }
//}
