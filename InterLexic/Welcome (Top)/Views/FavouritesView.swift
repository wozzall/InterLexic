//
//  FavouritesView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var favorites: Favorites
    
    var body: some View {
            VStack{
               
                Text("TabView_Favorites".localized)
                    .font(.title3)
                
                ScrollView(.vertical){
                    LazyVStack{
                        ForEach(favorites.flashCards) { flashCard in
                            HStack{
                                FlashCardView(flashCard: flashCard)
                                Button {
                                    favorites.remove(flashCard)
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
                self.favorites.flashCards = sortByAlphabetical()
            }
        }
    
    private func sortByAlphabetical() -> Array<FlashCard> {
        self.favorites.flashCards.sorted()
            }
}




struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
