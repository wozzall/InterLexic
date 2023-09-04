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
                Text(flashCard.sourceLanguage.name)
                    .frame(width: UIScreen.main.bounds.width * 0.35)
                    .font(Font.body.weight(.light))
                Image(systemName: "arrow.right")
                    .opacity(0.5)
                Text(flashCard.targetLanguage.name)
                    .frame(width: UIScreen.main.bounds.width * 0.35)
                    .font(Font.body.weight(.bold))
            }
            .foregroundColor(.gray)
            .padding(15)
            
            Divider()

            
            HStack{
                Text(flashCard.sourceString)
                    .font(Font.body.weight(.light))
                    .textSelection(.enabled)
                    .padding(.horizontal)
                
                
                
                Spacer()
                if textToSpeech.audioAvailable(inputString: flashCard.sourceString, googleLanguageCode: flashCard.sourceLanguage.translatorID){
                    Button {
                        textToSpeech.languageRecognizer.reset()
                        textToSpeech.synthesizeSpeech(inputMessage: flashCard.sourceString)
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
                        .padding(.trailing, 15)
                }
            }
            .padding(15)
            
            Divider()
            HStack{
                Text(flashCard.targetString)
                    .font(Font.body.weight(.bold))
                    .textSelection(.enabled)
                    .padding(.horizontal)
                
                Spacer()
                if textToSpeech.audioAvailable(inputString: flashCard.targetString, googleLanguageCode: flashCard.targetLanguage.translatorID){
                    Button {
                        textToSpeech.languageRecognizer.reset()
                        textToSpeech.synthesizeSpeech(inputMessage: flashCard.targetString)
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
                            .padding(.trailing, 15)
                    }
                }
            .padding(15)
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
}

//struct FlashCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardView(flashCard: FlashCard(sourceLanguage: "English", sourceString: "Hello", targetLanguage: "Chinese (Simplified)", targetString: "你好", id: UUID()))
//    }
//}
