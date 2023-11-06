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
    
    var flashCard: FlashCard
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.offWhite)
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
                AudioButton(textToSpeech: textToSpeech, text: flashCard.sourceString, translatedLanguage: flashCard.sourceLanguage)
                    .padding(.vertical)
                
                Divider()
                
                Text(flashCard.targetLanguage.name)
                    .font(Font.body.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(0.4)
                    .padding(.vertical)
                Text(flashCard.targetString)
                    .font(Font.body.weight(.bold))
                    .textSelection(.enabled)
                AudioButton(textToSpeech: textToSpeech, text: flashCard.targetString, translatedLanguage: flashCard.targetLanguage)
                    .padding(.vertical)
            }
            .padding()
            .multilineTextAlignment(.leading)
        }
    }
}
