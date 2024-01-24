//
//  TextToSpeech.swift
//  InterLexic
//
//  Created by George Worrall on 05/07/2023.
//

import Foundation
import AVFoundation
import NaturalLanguage

class TextToSpeech: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    let languageRecognizer = NLLanguageRecognizer()
    
    var devicePreferredLanguage: String {
        if #available(iOS 16, *) {
            let devicePreferredLanguage = Locale.current.identifier
            return devicePreferredLanguage
        } else {
            let devicePreferredLanguage = Locale.current.regionCode
            return devicePreferredLanguage!
        }
    }
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
        AVSpeechSynthesisVoice.speechVoices()	
    }
    
    func findAudioLanguageCode(inputString: String, inputLanguageCode: String) ->  String {
        
        let languageCode = inputLanguageCode.prefix(2)
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        for voice in voices where voice.language.contains(languageCode) {
            if languageCode == devicePreferredLanguage.prefix(2) {
                return devicePreferredLanguage
            }
            if voice.language.contains(languageCode) {
                return voice.language
            }
        }
        return String("Error!")
    }
    //MARK - Searches AVSpeechSynthesis voices array for a voice that matches the language of the inputted string.
    
    func isAudioAvailable(inputString: String, googleLanguageCode: String) -> Bool {
        
        languageRecognizer.reset()
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
    //MARK - Uses the NaturalLanguage module's languageRecognizer to match an Apple recognised language code to a Google translated language. If it returns true, the audio button icon lights up on TranslatorView or on the CardsView.
    
    func synthesizeSpeech(inputMessage: String, inputLanguageCode: String) {
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, options: .duckOthers)
        } catch let error {
            print("This error message from SpeechSynthesizer \(error.localizedDescription)")
        }
        let languageCode = findAudioLanguageCode(inputString: inputMessage, inputLanguageCode: inputLanguageCode)
        let utterance = AVSpeechUtterance(string: inputMessage)
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }
    //MARK - Requests the AVSpeechSynthesizer to produce speech based on the inputMessage and inputLanguageCode parameters. Ensures audio output ducks other background audio. Tapping the audio button a second time will stop the speech, and restart it from the beginning. This avoids overlap.
}
