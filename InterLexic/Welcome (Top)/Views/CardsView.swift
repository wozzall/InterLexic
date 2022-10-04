//
//  FavouritesView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

import SwiftUI

struct CardsView: View {
    
    @EnvironmentObject var flashCardStorage: FlashCardStorage

    @State var cardDeck: FlashCardDeck
    
    var body: some View {
        ScrollView(.vertical){
            List{
                ForEach(flashCardStorage.flashCardDecks) { flashCardDeck in
                    Text("\(flashCardDeck.sourceLanguage + " -> " + flashCardDeck.targetLanguage)")
                    ForEach(flashCardDeck.flashCards) { flashCard in
                        HStack{
                            FlashCardView(flashCard: flashCard)
//                            Button {
//                                flashCardStorage.removeCard
//                            } label: {
//                                ZStack{
//                                    Circle()
//                                        .foregroundColor(.gray)
//                                        .opacity(1)
//                                        .frame(width: 30, height: 30, alignment: .trailing)
//                                    Image(systemName: "trash")
//                                        .foregroundColor(.white)
//                                }
//                            }
//                            Spacer()
                        }
                    }
                    
                }
                .onDelete(perform: flashCardStorage.removeCard)
            }
            .toolbar {
                EditButton()
            }
        }
        .padding()
        .onAppear {
            self.flashCardStorage.flashCardDecks = sortByAlphabetical()
        }
    }
    
    private func sortByAlphabetical() -> Array<FlashCardDeck> {
        self.flashCardStorage.flashCardDecks.sorted()
    }
}




//struct FavouritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardsView()
//    }
//}
