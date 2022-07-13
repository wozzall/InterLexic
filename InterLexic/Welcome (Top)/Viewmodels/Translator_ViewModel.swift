//
//  TranslatorView_ViewModel.swift
//  InterLexic
//
//  Created by George Worrall on 08/04/2022.
//
import Combine
import Foundation

class TranslatorViewModel: ObservableObject {
        
    var model: TranslationManager
    
    @Published var translatedString: String
    @Published var languageA: Language?
    @Published var languageB: Language?
    @Published var toFromDirection: Bool
    // MARK - True = to, False = from
    @Published var translatableText: String?

    
    init() {
        self.model = TranslationManager()
        self.translatedString = String()
        self.toFromDirection = false
    }
    
    func initiateTranslation(text: String, sourceLanguage: String, targetLanguage: String, sameLanguage: Bool) {
        
        if sameLanguage {
            self.translatedString = text
        }
        
        TranslationManager.shared.sourceLanguageCode = sourceLanguage
        TranslationManager.shared.textToTranslate = text
        TranslationManager.shared.targetLanguageCode = targetLanguage
        
        TranslationManager.shared.translate(completion: { (translation) in
            print(translation!)
            DispatchQueue.main.async {
                self.translatedString = translation!
            }
        })
    }
    
    func defaultLanguageSelector(A: Language, B: Language) {
        
            if A.name == "" {
                languageA = Language(name: "languageSelectors_English".localized, translatorID: "en", id: UUID())
                if B.name == "" {
                   languageB = Language(name: "languageSelectors_ChineseSimp".localized, translatorID: "zh-CN", id: UUID())
                    return
                }
            }
        return
    }
    
    func changeLanguages(toFromDirection: Bool, in language: Language) {
        if toFromDirection {
            languageB = language
        }
        else {
            languageA = language
        }
    }
    
    func setDirection(direction: Bool) {
        toFromDirection = direction
    }
}


