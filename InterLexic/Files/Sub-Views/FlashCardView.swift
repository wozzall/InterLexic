//
//  FlashCardView.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import SwiftUI

struct FlashCardView: View {
    
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
            
            Text(flashCard.sourceString)
                .font(Font.body.weight(.light))
                .textSelection(.enabled)
                .padding(.horizontal)
            
            Divider()

            Text(flashCard.targetString)
                .font(Font.body.weight(.bold))
                .textSelection(.enabled)
                .padding(.horizontal)
        }
        .multilineTextAlignment(.leading)
//        .border(Color.black.opacity(0.4))
        .background(Color.white)
    }
}

//struct FlashCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardView(flashCard: FlashCard(sourceLanguage: "English", sourceString: "Hello", targetLanguage: "Chinese (Simplified)", targetString: "你好", id: UUID()))
//    }
//}
