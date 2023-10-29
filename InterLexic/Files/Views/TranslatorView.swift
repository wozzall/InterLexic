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
    
    
    @State private var translatableText: String = String()
    let textEditorPlaceHolder: String = "Type text here to detect language or to translate!"
    let textEditorCharLimit = 250
    @State var textEditorCharCount = 0
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
    @State var languageDetectionRequired = false
    @State var hasTranslated: Bool = false
    @State var hasDetected: Bool = false
    @State var hideDetect: Bool = false
    
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
                
                languageSelectorButtonsView
                
                
                textEditorView
                
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
                
                //                receivedTranslationEditor
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
            .onTapGesture {
                focusedField = nil
            }
            .onChange(of: languageB) { newLanguage in
                if hasTranslated {
                    viewModel.translatedString = String()
                    hasTranslated = false
                }
            }
        }
    }
    
    var languageSelectorButtonsView: some View {
        HStack {
            Button {
                viewModel.setDirection(direction: false)
                didTapSelector(doNotPassDetectOn: false)
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
                didTapSelector(doNotPassDetectOn: true)
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
    
    var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            //            Color.gray
            //                .opacity(0)
            //                .clipShape(RoundedRectangle(cornerRadius: 15))
            //                .frame(height: UIScreen.main.bounds.height * 0.25)
            //            if translatableText.isEmpty {
            //                Text("Buffer")
            //                    .opacity(!translatableText.isEmpty ? 1 : 0)
            //                    .padding(30)
            //            } else {
            //                Text(translatableText)
            //                    .opacity(!translatableText.isEmpty ? 1 : 0)
            //                    .padding(30)
            //            }
            //
            TextEditor(text: $translatableText)
                .frame(height: UIScreen.main.bounds.height * 0.25, alignment: .leading)
                .cornerRadius(15)
                .multilineTextAlignment(.leading)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
                .focused($focusedField, equals: .sourceTextWithDetection)
                .textSelection(.enabled)
                .onChange(of: translatableText) { _ in
                    translatableText = String(translatableText.prefix(textEditorCharLimit))
                    textEditorCharCount = translatableText.count
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1))
            
                .overlay(alignment: .topTrailing) {
                    if !translatableText.isEmpty{
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
                        
                        
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    HStack(spacing: 10){
                        
                        
                        if textEditorCharCount == textEditorCharLimit {
                            Text("\(textEditorCharCount) / \(textEditorCharLimit)" )
                                .foregroundColor(.red)
                        } else {
                            
                            Text("\(textEditorCharCount) / \(textEditorCharLimit)" )
                                .opacity(0.4)
                        }
                        
                        if textToSpeech.isAudioAvailable(inputString: translatableText, googleLanguageCode: languageA.translatorID){
                            Button {
                                textToSpeech.languageRecognizer.reset()
                                textToSpeech.synthesizeSpeech(inputMessage: translatableText)
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(.blue.opacity(0.8))
                                    .font(.title3)
                                    .padding(.top, 2)
                            }
                            
                        } else {
                            Image(systemName: "speaker.slash.fill")
                                .foregroundColor(.gray.opacity(0.2))
                                .font(.title3)
                                .padding(.top, 2)
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                }
                .overlay(alignment: .bottomLeading) {
                    if translatableText.isEmpty == false {
                        if languageDetectionRequired {
                            
                            HStack(spacing: 0){
                                Text("\(detectedLanguage?.name ?? "".localized)")
                                    .foregroundColor(.blue)
                                
                                    .padding(.trailing, 4)
                                Text("translatorView_detected".localized)
                                    .foregroundColor(.gray.opacity(0.8))
                                
                            }
                            .padding()
                            .onTapGesture {
                                languageA = detectedLanguage ?? Language(name: "None Detected", translatorID: "", id: UUID())
                                languageDetectionRequired = false
                                hasDetected = false
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.blue.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                    )
                                    .padding(7)
                            }
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
            .frame(height: UIScreen.main.bounds.height * 0.25)
            .focused($focusedField, equals: .targetText)
            .textSelection(.enabled)
            .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .overlay(alignment: .bottomTrailing) {
                if textToSpeech.isAudioAvailable(inputString: viewModel.translatedString, googleLanguageCode: languageB.translatorID){
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
            .focused($focusedField, equals: .targetText)
            .toast(isPresenting: $tappedSave, message: "translatorView_translationSaved".localized)
    }
    
    var receivedTranslationField: some View {
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .multilineTextAlignment(.leading)
                .focused($focusedField, equals: .targetText)
                .textSelection(.enabled)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1)
                }
                .overlay(alignment: .bottomTrailing) {
                    if textToSpeech.isAudioAvailable(inputString: viewModel.translatedString, googleLanguageCode: languageB.translatorID){
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
                .focused($focusedField, equals: .targetText)
                .toast(isPresenting: $tappedSave, message: "translatorView_translationSaved".localized)
            Text(viewModel.translatedString)
                .textSelection(.enabled)
                .padding(30)
                
        }
        .frame(minWidth: UIScreen.main.bounds.width * 0.8, minHeight: UIScreen.main.bounds.height * 0.3)

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
        self.disabledSave = false
        self.focusedField = nil
        self.tappedSave = false
        self.hasTranslated = true
    }
    
//    private func didTapDetect() {
//        manager.detectLanguage(forText: translatableText) { result in
//            for language in manager.supportedLanguages {
//                if manager.sourceLanguageCode == language.translatorID {
//                    hasDetected = true
//                    detectedLanguage = language
//                }
//            }
//        }
//    }
    
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
