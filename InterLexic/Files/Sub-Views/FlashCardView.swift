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
    @State var synthesizer = AVSpeechSynthesizer()
    
    var flashCard: FlashCard
    
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(flashCard.sourceLanguage)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: UIScreen.main.bounds.width * 0.35)
                    .font(Font.body.weight(.light))
                Image(systemName: "arrow.right")
                    .opacity(0.5)
                Text(flashCard.targetLanguage)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: UIScreen.main.bounds.width * 0.35)
                    .font(Font.body.weight(.bold))
                
            }
            .foregroundColor(.gray)
            .padding()
            
            Divider()
                .padding(.leading, 30)

            
            HStack{
                Text(flashCard.sourceString)
                    .font(Font.body.weight(.light))
                    .textSelection(.enabled)
                    .padding(.horizontal)
                    .padding(.vertical, 10)

            Spacer()
                Button {
                    textToSpeech.languageRecognizer.reset()
                    textToSpeech.synthesizeSpeech(inputMessage: flashCard.sourceString)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.blue.opacity(0.8))
                        .font(.title3)
                }
            }
            Divider()
                .padding(.leading, 30)
            HStack{
                Text(flashCard.targetString)
                    .font(Font.body.weight(.bold))
                    .textSelection(.enabled)
                    .padding(.horizontal)
                    .padding(.bottom, 15)

                Spacer()
                Button {
                    textToSpeech.languageRecognizer.reset()
                    textToSpeech.synthesizeSpeech(inputMessage: flashCard.targetString)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.blue.opacity(0.8))
                        .font(.title3)
                }
            }
        }
        .multilineTextAlignment(.leading)
//        .border(Color.black.opacity(0.4))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
        .shadow(color: .black.opacity(0.6), radius: 3, x: 2, y: 2)
        .overlay {
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .stroke(lineWidth: 2)
                .opacity(0.5)
        }
        
        
    }
    
    func synthesizeSpeech(inputMessage: String) {
        
        let languageCode = textToSpeech.isLanguageCodeAvailable(inputString: inputMessage)
        let utterance = AVSpeechUtterance(string: inputMessage)
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")

        synthesizer.speak(utterance)
    }
}

//struct FlashCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardView(flashCard: FlashCard(sourceLanguage: "English", sourceString: "Hello", targetLanguage: "Chinese (Simplified)", targetString: "你好", id: UUID()))
//    }
//}
