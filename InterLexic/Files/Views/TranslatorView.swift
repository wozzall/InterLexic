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
    
    @FocusState private var focusedField: Field?

    let pasteboard = UIPasteboard.general
    
    @State private var translatableText: String = String()
    let textEditorCharLimit = 200
    @State var textEditorCharCount = 0
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
    var audioAvailableA: Bool {
        if textToSpeech.isAudioAvailable(inputString: translatableText, googleLanguageCode: translatedLanguageA.translatorID) {
            return true
        }
        return false
    }
    var audioAvailableB: Bool {
        if textToSpeech.isAudioAvailable(inputString: viewModel.translatedString, googleLanguageCode: translatedLanguageB.translatorID) {
            return true
        }
        return false
    }
    
    init() {
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 35, right: 25)
        AVSpeechSynthesisVoice.speechVoices()
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
    
    var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $translatableText)
                .frame(height: UIScreen.main.bounds.height * 0.25, alignment: .leading)
                .cornerRadius(15)
                .multilineTextAlignment(.leading)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
                .focused($focusedField, equals: .sourceTextWithDetection)
                .textSelection(.enabled)
                .addRoundedBorder(color: .black)
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
                        Button {
                            textToSpeech.languageRecognizer.reset()
                            textToSpeech.synthesizeSpeech(inputMessage: translatableText, inputLanguageCode: translatedLanguageA.translatorID)
                        } label: {
                            Image(systemName: audioAvailableA ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .foregroundColor( audioAvailableA ? .blue.opacity(0.8) : .gray.opacity(0.2))
                                .font(.title3)
                                .disabled(audioAvailableA ? false : true )
                                .padding(.top, 4)
                                .padding(.trailing, 4)
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                }
                .overlay(alignment: .bottomLeading) {
                    if !translatableText.isEmpty && languageDetectionRequired {
                        Button {
                            didTapDetectedLanguage()
                        } label: {
                            Text(detectedLanguage?.name ?? "translatorView_detecting".localized)
                                .foregroundColor(.white)
                                .padding(10)
                                .background{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.blue.opacity(0.8))
                                        .addRoundedBorder(color: .black)
                                }
                        }
                        .padding()
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
                .fill(languagesAreSelected() && areNotSameLanguages() ? Color.blue : Color.offWhite.opacity(0.6))
                .shadow(color: languagesAreSelected() && areNotSameLanguages() ? Color.black.opacity(0.5) : Color.clear, radius: 2, x: 2, y: 2)
            Button(action: {
                didTapTranslate()
            }) {
                Text("translatorView_translateButton".localized)
            }
            .foregroundColor(languagesAreSelected() && areNotSameLanguages() ? .white : .gray)
            .buttonStyle(.borderless)
            .disabled(languagesAreSelected() && areNotSameLanguages() ? false : true)
        }
    }
    
    var saveTranslationButton: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(disabledSave ? Color.offWhite : .yellow)
                .shadow(color: disabledSave ? Color.clear : Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                .addRoundedBorder(color: disabledSave ? Color.clear : .white)
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
                .addRoundedBorder(color: .black)
                .overlay(alignment: .bottomTrailing) {
                    HStack(spacing: 15){
                        Button {
                            copyToClipBoard()
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue.opacity(0.8))
                                .font(.title3)
                        }
                        Button {
                            textToSpeech.languageRecognizer.reset()
                            textToSpeech.synthesizeSpeech(inputMessage: viewModel.translatedString, inputLanguageCode: translatedLanguageB.translatorID)
                        } label: {
                            Image(systemName: audioAvailableB ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .foregroundColor( audioAvailableB ? .blue.opacity(0.8) : .gray.opacity(0.2))
                                .font(.title3)
                                .disabled(audioAvailableB ? false : true )
                                .padding(.top, 4)
                                .padding(.trailing, 4)
                        }
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
        .toast(isPresenting: $hasCopied, message: "translatorView_translationCopied".localized)
        .focused($focusedField, equals: .targetText)
    }
    
    /// Instructs the Google Translate API to activate the Detect function and then display the result to the user by comparing its language code to the list of languages provided by the API.
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
    
    /// Returns a boolean value based on whether the user has selected languages to translate with. Translate button is disabled until the user has made a selection in both fields.
    /// - Returns: Returns a boolean value based on whether the user has selected languages to translate with. Translate button is disabled until the user has made a selection in both fields.
    private func languagesAreSelected() -> Bool {
        if languageA.name.isEmpty || languageB.name.isEmpty {
            return false
        }
        return true
    }
    
    /// Verifies that the two languages selected are not of the same value. Translate button remains disabled until two different languages are selected.
    /// - Returns: Verifies that the two languages selected are not of the same value. Translate button remains disabled until two different languages are selected.
    private func areNotSameLanguages() -> Bool {
        if languageA == languageB {
            return false
        }
        return true
    }
    
    /// Clears textEditorView of text and in turn the receivedTranslationField's text box. Allows user to quickly start a new translation.
    private func didTapClearText() {
        translatableText = String()
        viewModel.translatedString = String()
    }
    
    /// Stops the Cloud Translation API Detect function once the user has selected the detected language. Reduces overusage of API and reduces overhead costs at when scaled up.
    private func didTapDetectedLanguage() {
        languageA = detectedLanguage ?? Language(name: "???", translatorID: "", id: UUID())
        languageDetectionRequired = false
        hasDetected = false
    }
    
    /// Instructs the viewModel to initiate translation. Also retains current language selection so that user can change language selector fields without losing functionality of the audio buttons. disabledSave and tappedSave are also set to false as a new translation has been carried out and the user may wish to save. Equally, hasTranslated becomes true which disables the translation button until the user has made a new selection. This in turn increases efficiency and reduces wasted throughput on the API.
    private func didTapTranslate() {
        viewModel.initiateTranslation(text: translatableText, sourceLanguage: languageA.translatorID, targetLanguage: languageB.translatorID, sameLanguage: sameLanguage)
        self.translatedLanguageA = languageA
        self.translatedLanguageB = languageB
        self.disabledSave = false
        self.focusedField = nil
        self.tappedSave = false
        self.hasTranslated = true
    }
    
    /// Checks flashcard has not already been saved before allowing the user to save.
    private func saveButton() {
        if tappedSave != true {
            let newFlashCard = FlashCard(sourceLanguage: languageA, sourceString: translatableText, targetLanguage: languageB, targetString: viewModel.translatedString, id: UUID())
            flashCardStorage.add(newFlashCard)
            tappedSave = true
        }
        return
    }
    
    /// Copies translatedString to device's pasteboard. hasCopied triggers a toast to show the user the string has been copied.
    private func copyToClipBoard() {
        pasteboard.string = viewModel.translatedString
        self.hasCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.hasCopied = false
        })
    }
}
