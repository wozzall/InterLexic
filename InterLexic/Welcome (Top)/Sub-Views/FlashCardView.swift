//
//  FlashCardView.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import SwiftUI

struct FlashCardView: View {
    
    @EnvironmentObject var favorites: Favorites
    var flashCard: FlashCard
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray)
                    .frame(width: geo.size.width*0.9, height: geo.size.height*0.3, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.white)
                            .opacity(0.9)
                            .padding(4)
                    )
                VStack{
                    HStack(spacing: 50){
                        Text(flashCard.sourceLanguage)
                        
                        Image(systemName: "arrow.right")
                            .font(.largeTitle)
                        
                        Text(flashCard.targetLanguage)
                    }
                    .font(.title3)
                    
                    Divider()
                        .padding(.horizontal, 22)
                    Text(flashCard.sourceString)
                        .padding()
                    
                    Divider()
                        .padding(.horizontal, 22)
                    Text(flashCard.targetString)
                        .padding()
                    
                }
                .multilineTextAlignment(.center)
            }
            .overlay(
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            favorites.remove(flashCard)
                        } label: {
                            ZStack{
                                Circle()
                                    .foregroundColor(.gray)
                                    .opacity(1)
                                    .frame(width: geo.size.width*0.1, height: geo.size.height*0.1, alignment: .trailing)
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            )}
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(flashCard: FlashCard(sourceLanguage: "English", sourceString: "Hello", targetLanguage: "Chinese (Simplified)", targetString: "你好", id: UUID()))
    }
}
