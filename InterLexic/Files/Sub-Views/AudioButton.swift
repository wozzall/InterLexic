//
//  AudioButtonView.swift
//  InterLexic
//
//  Created by George Worrall on 31/10/2023.
//

import SwiftUI

struct AudioButton: View {
    
    let textToSpeech: TextToSpeech
    
    @State var text: String
    @State var translatedLanguage: Language
    
    var audioAvailable: Bool {
        if textToSpeech.isAudioAvailable(inputString: text, googleLanguageCode: translatedLanguage.translatorID) {
            return true
        }
        return false
    }
    
    var body: some View {
            Button {
                textToSpeech.languageRecognizer.reset()
                textToSpeech.synthesizeSpeech(inputMessage: text, inputLanguageCode: translatedLanguage.translatorID)
            } label: {
                Image(systemName: audioAvailable ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .foregroundColor( audioAvailable ? .blue.opacity(0.8) : .gray.opacity(0.2))
                    .font(.title3)
                    .disabled(audioAvailable ? false : true )
                    .padding(.top, 4)
                    .padding(.trailing, 4)
            }
    }
}

//#Preview {
//    AudioButtonView()
//}
