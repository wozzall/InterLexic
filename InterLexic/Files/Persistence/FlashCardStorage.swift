//
//  FlashCardStorage.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import Foundation

class FlashCardStorage: ObservableObject {
    
    @Published var flashCards: Array<FlashCard>
    @Published var flashCardDecks: Array<FlashCardDeck> = []
    @Published var sectionNames: Array<String> = []
    @Published var hasLoaded: Bool = false

    private var saveKey = "flashCardDecks"
    
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Array<FlashCard>.self, from: data) {
                flashCards = decoded
                return
            }
        }
        let sampleCard = FlashCard(sourceLanguage: "English", sourceString: "This is a sample flashcard", targetLanguage: "Chinese (Simplified)", targetString: "这是闪卡例子", id: UUID())
        flashCards = [sampleCard]
    }
    
    func sortIntoDecks() -> Array<FlashCardDeck> {
        
        let decks: Array<FlashCardDeck> = []
        for flashCard in flashCards {
            for var deck in decks {
                let cardPair: String = flashCard.sourceLanguage + flashCard.targetString
                let deckPair: String = deck.sourceLanguage + deck.targetLanguage
                
                if !deck.flashCards.contains(flashCard) {
                    flashCardDecks.append(FlashCardDeck(id: UUID(), name: flashCard.sourceLanguage + " -> " + flashCard.targetLanguage, sourceLanguage: flashCard.sourceLanguage, targetLanguage: flashCard.targetLanguage, flashCards: [flashCard]))
                    if !sectionNames.contains(flashCard.sourceLanguage) {
                        sectionNames.append(flashCard.sourceLanguage)
                    }
                } else if cardPair == deckPair {
                    deck.flashCards.append(flashCard)
                }
            }
        }
        return decks
    }
    
    func containsCard(_ flashCard: FlashCard) -> Bool {
        if flashCards.contains(flashCard){
            return true
        }
        return false
    }
    
    
    func add(_ flashCard: FlashCard) {
        self.flashCards.append(flashCard)
        self.flashCards.sort()
        save()
    }
    
    func removeCard(selectedCard: FlashCard) {
        objectWillChange.send()
        let selectedIndex = self.flashCards.firstIndex { $0.id == selectedCard.id }
        self.flashCards.remove(at: selectedIndex!)
        save()
    }
    
    func removeDeck(at offsets: IndexSet) {
        objectWillChange.send()
        flashCards.remove(atOffsets: offsets)
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(flashCards) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
