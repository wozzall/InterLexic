//
//  FlashCardView.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import SwiftUI
import AVFoundation

struct FlashCardView: View {
    
    @ObservedObject var textToSpeech = TextToSpeech()
    @Binding var synthesizer: AVSpeechSynthesizer
    
    var audioAvailableSource: Bool {
        if textToSpeech.isAudioAvailable(inputString: flashCard.sourceString, googleLanguageCode: flashCard.sourceLanguage.translatorID) {
            return true
        }
        return false
    }
    
    var audioAvailableTarget: Bool {
        if textToSpeech.isAudioAvailable(inputString: flashCard.targetString, googleLanguageCode: flashCard.targetLanguage.translatorID) {
            return true
        }
        return false
    }
    
    var flashCard: FlashCard
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .addRoundedBorder(color: .black)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2)
            
            VStack(alignment: .leading) {
                Text(flashCard.sourceLanguage.name)
                    .font(Font.body.weight(.light))
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(0.4)
                    .padding(.vertical)
                Text(flashCard.sourceString)
                    .font(Font.body.weight(.light))
                    .textSelection(.enabled)
                Button {
                    textToSpeech.languageRecognizer.reset()
                    textToSpeech.synthesizeSpeech(inputMessage: flashCard.sourceString, inputLanguageCode: flashCard.sourceLanguage.translatorID)
                } label: {
                    Image(systemName: audioAvailableSource ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .foregroundColor( audioAvailableSource ? .blue.opacity(0.8) : .gray.opacity(0.2))
                        .font(.title3)
                        .disabled(audioAvailableSource ? false : true )
                        .padding(.vertical)
                }
                
                Divider()
                
                Text(flashCard.targetLanguage.name)
                    .font(Font.body.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(0.4)
                    .padding(.vertical)
                Text(flashCard.targetString)
                    .font(Font.body.weight(.bold))
                    .textSelection(.enabled)
                Button {
                    textToSpeech.languageRecognizer.reset()
                    textToSpeech.synthesizeSpeech(inputMessage: flashCard.targetString, inputLanguageCode: flashCard.targetLanguage.translatorID)
                } label: {
                    Image(systemName: audioAvailableTarget ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .foregroundColor( audioAvailableTarget ? .blue.opacity(0.8) : .gray.opacity(0.2))
                        .font(.title3)
                        .disabled(audioAvailableTarget ? false : true )
                        .padding(.vertical)
                }
            }
            .padding()
            .multilineTextAlignment(.leading)
        }
    }
}
