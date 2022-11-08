//
//  FlashCardView.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import SwiftUI

struct FlashCardView: View {
    
    var source: String
    var target: String
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                
            VStack(alignment: .leading) {
                Text(source)
                    .font(.subheadline)
                    .textSelection(.enabled)
                Divider()
                Text(target)
                    .font(.headline)
                    .textSelection(.enabled)
            }
        }
    }
}

//struct FlashCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardView(flashCard: FlashCard(sourceLanguage: "English", sourceString: "Hello", targetLanguage: "Chinese (Simplified)", targetString: "你好", id: UUID()))
//    }
//}
