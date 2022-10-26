//
//  FlashCardStorage.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import Foundation

class FlashCardStorage: ObservableObject {
        
    @Published var flashCardDecks: Array<FlashCardDeck>
    private var saveKey = "flashCardDecks"
    
    var isDeck = false
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Array<FlashCardDeck>.self, from: data) {
                flashCardDecks = decoded
                return
            }
        }
        let sampleDeck = FlashCardDeck(id: UUID(), name: "English to Chinese (Simplified)" , sourceLanguage: "English", targetLanguage: "Chinese (Simplified)",  flashCards: [
            FlashCard(sourceLanguage: "English", sourceString: "This is a sample flashcard", targetLanguage: "Chinese (Simplified)", targetString: "这是闪卡例子", id: UUID())])
        flashCardDecks = [sampleDeck]
    }
    
    
    func containsCard(_ flashCard: FlashCard) -> Bool {
        for flashCardDeck in flashCardDecks {
            if flashCardDeck.flashCards.contains(flashCard){
                return true
            }
        }
        return false
    }
    
    func containsDeck(_ flashCardDeck: FlashCardDeck) -> Bool {
        if flashCardDecks.contains(flashCardDeck) {
            return true
        }
        return false
    }
    
    func add(_ flashCard: FlashCard) {
        objectWillChange.send()
        for var flashCardDeck in self.flashCardDecks {
            if flashCard.sourceLanguage == flashCardDeck.sourceLanguage && flashCard.targetLanguage == flashCardDeck.targetLanguage {
                flashCardDeck.flashCards.append(flashCard)
                save()
                return
            }
            else {
                let newDeck = FlashCardDeck(id: UUID(), name: flashCard.sourceLanguage + " to " + flashCard.targetLanguage, sourceLanguage: flashCard.sourceLanguage, targetLanguage: flashCard.targetLanguage, flashCards: [flashCard])
                self.flashCardDecks.append(newDeck)
            }
        }
        save()
    }
    
    func removeCard(at offsets: IndexSet) {
        objectWillChange.send()
        for var flashCardDeck in flashCardDecks {
            flashCardDeck.flashCards.remove(atOffsets: offsets)
        }
        save()
    }
    
    func removeDeck(at offsets: IndexSet) {
        objectWillChange.send()
        flashCardDecks.remove(atOffsets: offsets)
        save()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(flashCardDecks) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
