//
//  Favorites.swift
//  InterLexic
//
//  Created by George Worrall on 13/07/2022.
//

import Foundation

class Favorites: ObservableObject {
    
    @Published var flashCards: Array<FlashCard>
    private var saveKey = "favorites"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Array<FlashCard>.self, from: data) {
                flashCards = decoded
                return
            }
        }
        flashCards = []
    }
    
    
    func contains(_ flashCard: FlashCard) -> Bool {
    
        flashCards.contains(flashCard)
    }
    
    func add(_ flashCard: FlashCard) {
        objectWillChange.send()
        flashCards.append(flashCard)
        save()
    }
    
    func remove(_ flashCard: FlashCard) {
        objectWillChange.send()
        if let index = flashCards.firstIndex(of: flashCard) {
            flashCards.remove(at: index)
        }
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(flashCards) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
