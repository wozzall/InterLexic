//
//  TextToSpeech.swift
//  InterLexic
//
//  Created by George Worrall on 05/07/2023.
//

import Foundation
import AVFoundation
import NaturalLanguage

class TextToSpeech: NSObject, ObservableObject {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    let languageRecognizer = NLLanguageRecognizer()
        
    let availableLanguages: Array<String> =
    ["ar-001","bg-BG","ca-ES","cs-CZ","da-DK","de-DE","de-DE","de-DE","de-DE","de-DE","de-DE","de-DE","de-DE","de-DE","de-DE","de-DE","el-GR","en-AU","en-AU","en-AU","en-GB","en-GB","en-GB","en-GB","en-GB","en-GB","en-GB","en-GB","en-GB","en-GB","en-GB","en-IE","en-IN","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-US","en-ZA","es-ES","es-ES","es-ES","es-ES","es-ES","es-ES","es-ES","es-ES","es-ES","es-MX","es-MX","es-MX","es-MX","es-MX","es-MX","es-MX","es-MX","es-MX","fi-FI","fi-FI","fi-FI","fi-FI","fi-FI","fi-FI","fi-FI","fi-FI","fi-FI","fr-CA","fr-CA","fr-CA","fr-CA","fr-CA","fr-CA","fr-CA","fr-CA","fr-CA","fr-FR","fr-FR","fr-FR","fr-FR","fr-FR","fr-FR","fr-FR","fr-FR","fr-FR","fr-FR","fr-FR","he-IL","hi-IN","hr-HR","hu-HU","id-ID","it-IT","it-IT","it-IT","it-IT","it-IT","it-IT","it-IT","it-IT","it-IT","ja-JP","ja-JP","ja-JP","ko-KR","ms-MY","nb-NO","nl-BE","nl-NL","pl-PL","pt-BR","pt-BR","pt-BR","pt-BR","pt-BR","pt-BR","pt-BR","pt-BR","pt-BR","pt-PT","ro-RO","ru-RU","sk-SK","sv-SE","th-TH","tr-TR","uk-UA","vi-VN","zh-CN","zh-CN","zh-CN","zh-HK","zh-TW"]
    
    func isLanguageCodeAvailable(inputString: String) ->  String {
        
        languageRecognizer.reset()

        languageRecognizer.processString(inputString)
        
        if let appleRecognisedLanguage = languageRecognizer.dominantLanguage?.rawValue {
            let languageCode = appleRecognisedLanguage.prefix(2)
            let voices = AVSpeechSynthesisVoice.speechVoices()
            for	voice in voices where voice.language.contains(languageCode) {
                print(voice.language + voice.name)
                return voice.language
            }
        }
        return String("Error!")
    }
    
    func isAudioAvailable(inputString: String, googleLanguageCode: String) -> Bool {
        
        languageRecognizer.processString(inputString)
        
        if let appleRecognizedLanguage = languageRecognizer.dominantLanguage?.rawValue {
            let appleCode = appleRecognizedLanguage.prefix(2)
            let googleCode = googleLanguageCode.prefix(2)
            if appleCode == googleCode {
                return true
            }
        }
        return false
    }
    
    func synthesizeSpeech(inputMessage: String) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)
        } catch let error {
            print("This error message from SpeechSynthesizer \(error.localizedDescription)")
        }
        let languageCode = isLanguageCodeAvailable(inputString: inputMessage)
        let utterance = AVSpeechUtterance(string: inputMessage)
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    
    }
    
    
}
