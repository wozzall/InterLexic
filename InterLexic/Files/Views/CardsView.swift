//
//  FavouritesView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

//import SwiftUI
//
//struct CardsView: View {
//    
//    @EnvironmentObject var flashCardStorage: FlashCardStorage
//    
//    @State var cardDeck: FlashCardDeck
//    
//    var body: some View {
//            List{
//                ForEach(cardDeck.flashCards, id: \.id) { flashCard in
//                    FlashCardView(source: flashCard.sourceString, target: flashCard.targetString)
//                        .padding()
//                }
//                .onDelete(perform: flashCardStorage.removeCard)
//            }
//            .toolbar {
//                EditButton()
//            }
//            .navigationTitle(Text("\(cardDeck.sourceLanguage + " to " + cardDeck.targetLanguage)"))
//    }
//}




//struct FavouritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardsView()
//    }
//}
