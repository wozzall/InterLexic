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
    //MARK - Requests the translation method from the Cloud Translation API model passing the parameters given by the user and returns the translation to the translatedString property.
    
    func setDirection(direction: Bool) {
        toFromDirection = direction
    }
    //MARK - Changes viewModel languages depending on the toFromDirection boolean. In this case, true is 'from' direction and false is 'to' direction.

}


