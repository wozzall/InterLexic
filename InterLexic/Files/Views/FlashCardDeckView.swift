////
////  FlashCardDeckView.swift
////  InterLexic
////
////  Created by George Worrall on 05/09/2022.
////
//
//import SwiftUI
//
//struct FlashCardDeckView: View {
//    
//    @EnvironmentObject var flashCardStorage: FlashCardStorage
//    
//    @State var selectedNavigation: String?
//    @State var selection: FlashCardDeck?
//    @State var hasLoaded: Bool = false
////    var defaultDeck: FlashCardDeck
//    
//    init() {
//        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
////        defaultDeck = FlashCardDeck(id: UUID(), name: "Error", sourceLanguage: "English", targetLanguage: "Chinese", flashCards: [])
//    }
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(flashCardStorage.flashCardDecks, id: \.self) { deck in
//                    NavigationLink((deck.sourceLanguage + " -> " + deck.targetLanguage), tag: CardsView.navigation, selection: $selectedNavigation) {
//                        CardsView(cardDeck: deck)
//                    }
//                }
//                .onDelete(perform: flashCardStorage.removeCard)
//            }
//            .toolbar {
//                EditButton()
//            }
//            .navigationBarTitle(Text("Flashcard Decks"))
//        }
//        .onAppear(perform: showDecks)
//    }
//    
//    func showDecks() {
//        print(flashCardStorage.flashCards)
//    }
//}

//struct FlashCardDeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardDeckView()
//    }
//}
