//
//  FavouritesView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

import SwiftUI

struct CardsView: View {
    
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    
    var body: some View {
            VStack{
               
                Text("TabView_Favorites".localized)
                    .font(.title3)
                
                ScrollView(.vertical){
                    LazyVStack{
                        ForEach(flashCardStorage.flashCards) { flashCard in
                            HStack{
                                FlashCardView(flashCard: flashCard)
                                Button {
                                    flashCardStorage.remove(flashCard)
                                } label: {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(.gray)
                                            .opacity(1)
                                            .frame(width: 30, height: 30, alignment: .trailing)
                                        Image(systemName: "trash")
                                            .foregroundColor(.white)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                self.flashCardStorage.flashCards = sortByAlphabetical()
            }
        }
    
    private func sortByAlphabetical() -> Array<FlashCard> {
        self.flashCardStorage.flashCards.sorted()
    }
}




struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
