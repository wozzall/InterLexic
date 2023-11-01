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
    case sourceTextWithDetection
    case sourceText
    case targetText
}

struct TranslatorView: View {
    
    
    @EnvironmentObject var networkMonitor: Monitor
    @EnvironmentObject var manager: TranslationManager
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    
    @ObservedObject var viewModel = TranslatorViewModel()
    @ObservedObject var textToSpeech = TextToSpeech()
    @State var synthesizer = AVSpeechSynthesizer()
    var delegate: AVSpeechSynthesizerDelegate?
    
    let pasteboard = UIPasteboard.general
    
    @State private var translatableText: String = String()
    let textEditorPlaceHolder: String = "Type text here to detect language or to translate!"
    let textEditorCharLimit = 200
    @State var textEditorCharCount = 0
    @State private var translationEdit: String = String()
    @State private var languagesSupported: Array<Language> = []
    @State var selectedNavigation: String?
    
    @State var languageA: Language = Language(name: "", translatorID: "")
    @State var languageB: Language = Language(name: "", translatorID: "")
    @State var translatedLanguageA: Language = Language(name: "", translatorID: "")
    @State var translatedLanguageB: Language = Language(name: "", translatorID: "")
    @State var detectedLanguage: Language?
    
    @State var sameLanguage: Bool = false
    @State var tappedSave: Bool = false
    @State var disabledSave: Bool = true
    @State var showAlert: Bool = false
    @State var languageDetectionRequired = false
    @State var hasTranslated: Bool = false
    @State var hasDetected: Bool = false
    @State var hideDetect: Bool = false
    @State var hasCopied: Bool = false
    
    @FocusState private var focusedField: Field?
    
    init() {
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 35, right: 25)
    }
    
    var body: some View {
        NavigationView{
            ScrollView {
                NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                    LanguageSelectorView(languageA: $languageA, languageB: $languageB, toFromDirection: $viewModel.toFromDirection, languageDetectionRequired: $languageDetectionRequired, hideDetectButton: hideDetect)
                } label: {
                    EmptyView()
                }
                LanguageSelectorButtons(viewModel: viewModel, languageA: $languageA, languageB: $languageB, toFromDirection: $viewModel.toFromDirection, languageDetectionRequired: $languageDetectionRequired, hideDetect: $hideDetect, selectedNavigation: $selectedNavigation, isCardView: false)
//                languageSelectorButtonsView
                
                textEditorView
                
                HStack(spacing: 35){
                    translateButton
                    saveTranslationButton
                }
                .frame(height: 50)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                
                receivedTranslationField
                
                HStack {
                    Spacer()
                    Image("color-regular")
                        .padding(.bottom)
                        .padding(.trailing)
                }
            }
            .navigationBarTitle("tabView_translate".localized)
            .navigationBarHidden(true)
            .background(Color.offWhite.opacity(0.7))
            .onAppear {
                manager.fetchLanguages()
                if languageDetectionRequired {
                    detectLanguage()
                }
            }
            .onTapGesture { focusedField = nil }
            
            .onChange(of: languageB) { newLanguage in
                translatedLanguageB = newLanguage
                viewModel.translatedString = String()
                hasTranslated = false
            }
            .onChange(of: languageA) { newLanguage in
                translatedLanguageA = newLanguage
            }
        }
    }
    
//    var languageSelectorButtonsView: some View {
//        HStack {
//            Button {
//                viewModel.setDirection(direction: false)
//                didTapSelector(doNotPassDetectOn: false)
//            } label: {
//                ZStack {
//                    Color.offWhite
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
//                        .addBorder(color: .black)
//                    if languageA.name.isEmpty {
//                        Text("languageSelectorView_from".localized)
//                            .padding()
//                    }
//                    else if languageA.name == "Detecting..." {
//                        Text("Detecting...")
//                            .foregroundStyle(.green)
//                    }
//                    else {
//                        Text(languageA.name)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal)
//                    }
//                }
//                .foregroundColor(.blue)
//            }
//            Image(systemName: "arrow.right")
//                .foregroundColor(.accentColor)
//            Button {
//                viewModel.setDirection(direction: true)
//                didTapSelector(doNotPassDetectOn: true)
//            } label: {
//                ZStack {
//                    Color.offWhite
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
//                        .addBorder(color: .black)
//                    if languageB.name == "" {
//                        Text("languageSelectorView_to".localized)
//                            .padding()
//                    }
//                    else {
//                        Text(languageB.name)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal)
//                    }
//                }
//                .foregroundColor(.blue)
//            }
//        }
//        .frame(height: 50)
//        .padding(.horizontal)
//        .padding(.top, 30)
//        .buttonStyle(.borderless)
//    }
    
    var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $translatableText)
                .frame(height: UIScreen.main.bounds.height * 0.25, alignment: .leading)
                .cornerRadius(15)
                .multilineTextAlignment(.leading)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
                .focused($focusedField, equals: .sourceTextWithDetection)
                .textSelection(.enabled)
                .addBorder(color: .black)
                .onChange(of: translatableText) { _ in
                    translatableText = String(translatableText.prefix(textEditorCharLimit))
                    textEditorCharCount = translatableText.count
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        didTapClearText()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.black.opacity(0.2))
                            .frame(width: 20, height: 20)
                    }
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                    .buttonStyle(.borderless)
                    .opacity(translatableText.isEmpty ? 0 : 1 )
                    .disabled(translatableText.isEmpty ? true : false )
                }
                .overlay(alignment: .bottomTrailing) {
                    HStack(spacing: 10){
                        CharacterCounter(charCount: $textEditorCharCount, charLimit: textEditorCharLimit)
                        AudioButton(text: translatableText, translatedLanguage: translatedLanguageA)
                    }
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                }
                .overlay(alignment: .bottomLeading) {
                    if !translatableText.isEmpty && languageDetectionRequired {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.offWhite.opacity(0.1))
                                .addBorder(color: .black)
                                .padding(7)
                            Text(detectedLanguage?.name ?? "Detecting...")
                                .foregroundColor(.blue)
                                .padding(.trailing, 4)
                            //                                Text("translatorView_detected".localized)
                            //                                    .foregroundColor(.gray.opacity(0.8))
                        }
                        .padding()
                        
                        .onTapGesture {
                            languageA = detectedLanguage ?? Language(name: "None Detected", translatorID: "", id: UUID())
                            languageDetectionRequired = false
                            hasDetected = false
                        }
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .onChange(of: translatableText) { _ in
                    guard languageDetectionRequired else {
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                        detectLanguage()
                    }
                }
            if translatableText.isEmpty {
                VStack{
                    HStack{
                        Text("translatorView_textEditorPlaceholder".localized)
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
                .fill(languagesAreSelected() ? Color.blue : Color.offWhite.opacity(0.6))
                .shadow(color: languagesAreSelected() ? Color.black.opacity(0.5) : Color.clear, radius: 2, x: 2, y: 2)
            Button(action: {
                didTapTranslate()
            }) {
                Text("translatorView_translateButton".localized)
            }
            .foregroundColor(languagesAreSelected() ? .white : .gray)
            .buttonStyle(.borderless)
            .disabled(languagesAreSelected() ? false : true)
        }
    }
    
    var saveTranslationButton: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(disabledSave ? Color.offWhite : .yellow)
                .shadow(color: disabledSave ? Color.clear : Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                .addBorder(color: disabledSave ? Color.clear : .white)
                .opacity(disabledSave ? 0.6 : 1)
            Button(action: {
                saveButton()
                self.disabledSave = true
            }) {
                Text("translatorView_saveButton".localized)
                    .foregroundColor(disabledSave ? .gray : .white)
            }
            .buttonStyle(.borderless)
            .disabled(disabledSave ? true : false)
        }
    }
    
    var receivedTranslationField: some View {
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .multilineTextAlignment(.leading)
                .focused($focusedField, equals: .targetText)
                .textSelection(.enabled)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
                .frame(height: UIScreen.main.bounds.height * 0.25)
                .addBorder(color: .black)
                .overlay(alignment: .bottomTrailing) {
                    HStack(spacing: 15){
                        Button {
                            copyToClipBoard()
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue.opacity(0.8))
                                .font(.title3)
                        }
                        AudioButton(text: viewModel.translatedString, translatedLanguage: translatedLanguageB)
                    }
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                }
            Text(viewModel.translatedString)
                .textSelection(.enabled)
                .padding(15)
        }
        .padding()
        .toast(isPresenting: $tappedSave, message: "translatorView_translationSaved".localized)
        .toast(isPresenting: $hasCopied, message: "Translation copied!")
        .focused($focusedField, equals: .targetText)
    }
    
    private func detectLanguage() {
        manager.detectLanguage(forText: translatableText) { result in
            for language in manager.supportedLanguages {
                if manager.sourceLanguageCode == language.translatorID {
                    hasDetected = true
                    detectedLanguage = language
                }
            }
        }
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
    
    private func didTapAudio() -> Bool {
        if synthesizer.isSpeaking {
            return true
        }
        return false
    }
    
    private func didTapSelector(doNotPassDetectOn: Bool) {
        self.selectedNavigation = nil
        self.hideDetect = doNotPassDetectOn
        self.selectedNavigation = LanguageSelectorView.navigation
    }
    
    private func didTapClearText() {
        translatableText = String()
        viewModel.translatedString = String()
    }
    
    private func didTapTranslate() {
        viewModel.defaultLanguageSelector(A: languageA, B: languageB)
        viewModel.initiateTranslation(text: translatableText, sourceLanguage: languageA.translatorID, targetLanguage: languageB.translatorID, sameLanguage: sameLanguage)
        self.translatedLanguageA = languageA
        self.translatedLanguageB = languageB
        self.disabledSave = false
        self.focusedField = nil
        self.tappedSave = false
        self.hasTranslated = true
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
    
    private func copyToClipBoard() {
        pasteboard.string = viewModel.translatedString
        self.hasCopied = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.hasCopied = false
        }
        )
    }
}


//struct TranslatorView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        TranslatorView(languageA: Language(name: "", translatorID: "", id: UUID()), languageB: Language(name: "", translatorID: "", id: UUID()))
//    }
//}
