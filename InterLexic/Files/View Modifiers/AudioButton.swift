//
//  AudioButton.swift
//  InterLexic
//
//  Created by George Worrall on 05/10/2023.
//

import SwiftUI
import AVFoundation


struct AudioButton: ViewModifier {
    
    var synthesizer = AVSpeechSynthesizer()
    let textToSpeech = TextToSpeech()
    
    @Binding var language: Language
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                if textToSpeech.isAudioAvailable(inputString: text, googleLanguageCode: language.translatorID){
                    Button {
                        textToSpeech.languageRecognizer.reset()
                        textToSpeech.synthesizeSpeech(inputMessage: text)
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
    }
}
