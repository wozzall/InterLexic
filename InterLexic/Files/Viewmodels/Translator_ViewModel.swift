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
    
    /// Requests the translation method from the Cloud Translation API model passing the parameters given by the user and returns the translation to the translatedString property.
    /// - Parameters:
    ///   - text: User input text
    ///   - sourceLanguage: Source Language chosen by the user.
    ///   - targetLanguage: Target Language chosen by the user.
    ///   - sameLanguage: Boolean value that explains whether the source and target language are the same.
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
    
    /// Changes viewModel languages depending on the toFromDirection boolean.
    /// - Parameter direction:  True is 'from' direction and False is 'to' direction.
    func setDirection(direction: Bool) {
        toFromDirection = direction
    }
}


