//
//  FlashCardStorage.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import Foundation
import AVFoundation
import SwiftUI

class FlashCardStorage: ObservableObject {
    
    @Published var flashCards: Array<FlashCard>
    @Published var hasLoaded: Bool = false
    private var saveKey = "flashCardDecks"
    
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Array<FlashCard>.self, from: data) {
                flashCards = decoded
                return
            }
        }
        let sampleCard = FlashCard(sourceLanguage: Language(name: "English", translatorID: "en-GB"), sourceString: "This is a sample flashcard", targetLanguage: Language(name: "Chinese (Simplified)", translatorID: "zh-CN"), targetString: "这是闪卡例子", id: UUID())
        flashCards = [sampleCard]
    }
    
    /// Checks to see if the persisted array contains the selected flashcard.
    /// - Parameter flashCard: User generated Flashcard.
    /// - Returns: Boolean which describes if FlashCard is already in the storage.
    func containsCard(_ flashCard: FlashCard) -> Bool {
        if flashCards.contains(flashCard){
            return true
        }
        return false
    }
    
    
    /// Appends a new flashcard to the array and saves the change.
    /// - Parameter flashCard: Flashcard created by the user.
    func add(_ flashCard: FlashCard) {
        self.flashCards.append(flashCard)
        self.flashCards.sort()
        save()
    }
    
    /// Removes the selected flashcard using its ID property to delete exactly that card.
    /// - Parameter selectedCard: The Flashcard on which the delete button is presented.
    func removeCard(selectedCard: FlashCard) {
        withAnimation {
            objectWillChange.send()
            let selectedIndex = self.flashCards.firstIndex { $0.id == selectedCard.id }
            self.flashCards.remove(at: selectedIndex!)
        }
        save()
    }
    
    /// Encodes/saves the flashCards array to UserDefaults using the provided key.
    func save() {
        if let encoded = try? JSONEncoder().encode(flashCards) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
