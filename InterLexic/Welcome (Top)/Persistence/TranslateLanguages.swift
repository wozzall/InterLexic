//
//  TranslateLanguages.swift
//  InterLexic
//
//  Created by George Worrall on 08/08/2022.
//

import Foundation

class TranslatorLanguages: ObservableObject {
    
    @Published var languages: Array<Language>
    private var saveKey = "languages"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Array<Language>.self, from: data) {
                languages = decoded
                return
            }
        }
        languages = []
    }
    
    func contains(_ language: Language) -> Bool {
    
        languages.contains(language)
    }
    
    func add(_ language: Language) {
        objectWillChange.send()
        languages.append(language)
        save()
    }
    
    func remove(_ language: Language) {
        objectWillChange.send()
        if let index = languages.firstIndex(of: language) {
            languages.remove(at: index)
        }
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(languages) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func addLanguagesToPersistence(_ inputLanguages: Array<Language>) {
        for inputLanguage in inputLanguages {
            for language in languages {
                if language.name.contains(inputLanguage.name) == false {
                    self.add(inputLanguage)
                }
            }
        }
    }
}

