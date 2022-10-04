//
//  FlashCardDeckView.swift
//  InterLexic
//
//  Created by George Worrall on 05/09/2022.
//

import SwiftUI

struct FlashCardDeckView: View {
    
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    
    @State var selectedNavigation: String?
    
    @State var selection: FlashCardDeck?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(flashCardStorage.flashCardDecks) { flashCardDeck in
                        NavigationLink(tag: CardsView.navigation, selection: $selectedNavigation) {
                            CardsView(cardDeck: flashCardDeck)
                        } label: {
                            HStack {
                                Text("\(flashCardDeck.sourceLanguage)" + " -> " + "\(flashCardDeck.targetLanguage)")
                                
                            }
                        }
                    }
                    .onDelete(perform: flashCardStorage.removeDeck)
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }
}

//struct FlashCardDeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardDeckView()
//    }
//}
