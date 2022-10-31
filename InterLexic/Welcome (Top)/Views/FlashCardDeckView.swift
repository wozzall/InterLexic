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
//    var defaultDeck: FlashCardDeck
    
    init() {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
//        defaultDeck = FlashCardDeck(id: UUID(), name: "Error", sourceLanguage: "English", targetLanguage: "Chinese", flashCards: [])
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(flashCardStorage.flashCardDecks, id: \.id) { flashCardDeck in
                    NavigationLink(destination: CardsView(cardDeck: flashCardDeck)) {
                        Text(flashCardDeck.name)
                    }
                }
                .onDelete(perform: flashCardStorage.removeDeck)
            }
            .toolbar {
                EditButton()
            }
            .navigationBarTitle(Text("Saved Flashcard Decks"))
        }
        .onAppear(perform: showDecks)
    }
    
    func showDecks() {
        print(flashCardStorage.flashCardDecks)
    }
}

//struct FlashCardDeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardDeckView()
//    }
//}
