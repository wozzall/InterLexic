//
//  SupportedLanguages.swift
//  InterLexic
//
//  Created by George Worrall on 17/11/2022.
//

import Foundation

class SupportedLanguages: ObservableObject {
    
    @Published var languages: Array<Language>
    
    private var saveKey = "supportedLanguages"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Array<Language>.self, from: data) {
                languages = decoded
                return
            }
        }
        languages = [Language(name: "Sample", translatorID: String())]
    }
    
    func containsLanguage(_ language: Language) -> Bool {
        if languages.contains(language){
            return true
        }
        return false
    }
    
    func add(_ language: Language) {
        languages.append(language)
        save()
    }
    
    func removeLanguage(at offsets: IndexSet) {
        languages.remove(atOffsets: offsets)
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(languages) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
}
