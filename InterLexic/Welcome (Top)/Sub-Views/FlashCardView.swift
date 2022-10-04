//
//  FlashCardView.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import SwiftUI

struct FlashCardView: View {
    
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    var flashCard: FlashCard
    
    var body: some View {
//        ZStack {
//            Color.offWhite
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 15)
//                        .foregroundColor(.white)
//                        .opacity(0.9)
//                        .padding(4)
//                )
//            VStack{
//                HStack(spacing: 5){
//                    Text(flashCard.sourceLanguage)
//                        .fixedSize(horizontal: false, vertical: true)
//                    Image(systemName: "arrow.right")
//                        .font(.largeTitle)
//                    Text(flashCard.targetLanguage)
//                        .fixedSize(horizontal: false, vertical: true)
//
//                }
//                .padding()
//                .opacity(0.6)
//
//                Divider()
//                    .padding(.horizontal, 22)
        VStack{
            Text(flashCard.sourceString)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            Divider()
                .padding(.horizontal, 22)
            Text(flashCard.targetString)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                
//            }
           
        }
        .multilineTextAlignment(.center)
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(flashCard: FlashCard(sourceLanguage: "English", sourceString: "Hello", targetLanguage: "Chinese (Simplified)", targetString: "你好", id: UUID()))
    }
}
