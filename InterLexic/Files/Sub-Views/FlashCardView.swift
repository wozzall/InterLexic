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
        VStack(spacing: 10){
            HStack(alignment: .center) {
                Text(flashCard.sourceLanguage)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                Image(systemName: "arrow.right")
                    .opacity(0.8)
                Text(flashCard.targetLanguage)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                
            }
            Divider()
            Text(flashCard.sourceString)
                .padding()
            Divider()
            Text(flashCard.targetString)
                .padding()
        }
        .multilineTextAlignment(.leading)
    }
}

//struct FlashCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardView(flashCard: FlashCard(sourceLanguage: "English", sourceString: "Hello", targetLanguage: "Chinese (Simplified)", targetString: "你好", id: UUID()))
//    }
//}
