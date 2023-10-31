//
//  AudioButton.swift
//  InterLexic
//
//  Created by George Worrall on 05/10/2023.
//
//
//import SwiftUI
//import AVFoundation
//

//struct AudioButton: ViewModifier {
//    
//    var synthesizer = AVSpeechSynthesizer()
//    let textToSpeech = TextToSpeech()
//    
//    @Binding var language: Language
//    @Binding var text: String
//    
//    func body(content: Content) -> some View {
//        content
//            .overlay(alignment: .bottomTrailing) {
//                HStack(spacing: 10){
//                    if textEditorCharCount == textEditorCharLimit {
//                        Text("\(textEditorCharCount) / \(textEditorCharLimit)" )
//                            .foregroundColor(.red)
//                    } else {
//                        Text("\(textEditorCharCount) / \(textEditorCharLimit)" )
//                            .opacity(0.4)
//                    }
//                    
//                    if textToSpeech.isAudioAvailable(inputString: translatableText, googleLanguageCode: languageA.translatorID){
//                        Button {
//                            textToSpeech.languageRecognizer.reset()
//                            textToSpeech.synthesizeSpeech(inputMessage: translatableText, inputLanguageCode: translatedLanguageA.translatorID)
//                        } label: {
//                            Image(systemName: "speaker.wave.2.fill")
//                                .foregroundColor(.blue.opacity(0.8))
//                                .font(.title3)
//                                .padding(.top, 2)
//                        }
//                        
//                    } else {
//                        Image(systemName: "speaker.slash.fill")
//                            .foregroundColor(.gray.opacity(0.2))
//                            .font(.title3)
//                            .padding(.top, 2)
//                    }
//                }
//                .padding(.bottom, 10)
//                .padding(.trailing, 10)
//            }
