//
//  Translation API.swift
//  InterLexic
//
//  Created by George Worrall on 21/04/2022.
//

import Foundation

enum TranslationAPI {
    
    case detectLanguage
    case translate
    case supportedLanguages
    
    /// Returns a URL string based on the selected TranslationAPI enum value.
    /// - Returns: A string which contains the URL for the desired Cloud Translation API service.
    func getURL() -> String {
        var urlString = String()
        
        switch self {
        case .detectLanguage: urlString = "https://translation.googleapis.com/language/translate/v2/detect"
            
        case .translate: urlString = "https://translation.googleapis.com/language/translate/v2/"
            
        case .supportedLanguages: urlString = "https://translation.googleapis.com/language/translate/v2/languages"
        }
        return urlString
    }
    
    /// Returns the appropriate HTTP Request method based on the selected TranslationAPI enum value.
    /// - Returns: A string which describes 'GET' or 'POST' to give to the HTTP request.
    func getHTTPMethod() -> String {
        if self == .supportedLanguages {
            return "GET"
        } else {
            return "POST"
        }
    }
}


