//
//  TranslatorView_Model.swift
//  InterLexic
//
//  Created by George Worrall on 08/04/2022.
//

import Foundation
import SwiftUI
import Network

enum TranslationManagerError: String, Error {
    
    case fetchLanguages
    
    var errorDescription: String {
        "TranslationManagerError.\(self)".localized
        
        }

}

class TranslationManager: NSObject, ObservableObject {
        
    let network = Monitor()
    
    static let shared = TranslationManager()
        
    private var apiKey: String {
        get{
            guard let filePath = Bundle.main.path(forResource: "CloudTranslation", ofType: "plist") else {
                fatalError("Could't find file 'CloudTranslation.plist'.")
            }
            let pList = NSDictionary(contentsOfFile: filePath)
            guard let value = pList?.object(forKey: "API_KEY") as? String else {
                fatalError("Could find key 'API_KEY' in 'CloudTranslation.plist'.")
            }
            return value
        }
    }
    var supportedLanguages: Array<Language> = []
    
    var sourceLanguageCode: String?
    
    var textToTranslate: String?
    
    var targetLanguageCode: String?
    
    var isLoading: Bool = false
    
    var isDuplicate: Bool = false
    
    var hasLoaded: Bool = false
    
    @Published var isShowingAlert = false
    
    
    
    override init() {
        super.init()
    }
    
    private func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], completion: @escaping (_ results: [String:Any]?) -> Void) {
        
        if var components = URLComponents(string: api.getURL()) {
            components.queryItems = [URLQueryItem]()
            for (key, value) in urlParams {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            if let url = components.url {
                var request = URLRequest(url: url)
                request.httpMethod = api.getHTTPMethod()
                let session = URLSession(configuration: .default)
                session.configuration.timeoutIntervalForRequest = 5
                let task = session.dataTask(with: request) { (results, response, error) in
                    if let error = error {
                        print(error)
                        completion(nil)
                    } else {
                        if let response = response as? HTTPURLResponse, let results = results {
                            if response.statusCode == 200 || response.statusCode == 201 {
                                do {
                                    if let resultsDict = try JSONSerialization.jsonObject(with: results, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                                        completion(resultsDict)
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } else {
                            completion(nil)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    //MARK - Setup for URL session to make HTTP request and decode the JSON packet into a dictionary result with String: Any values.
    
    func detectLanguage(forText text: String, completion: @escaping (_ language: String?) -> Void) {
        
        let urlParams = ["key": apiKey, "q": text]
        makeRequest(usingTranslationAPI: .detectLanguage, urlParams: urlParams) { (results) in
            guard let results = results else { completion(nil); return }
            if let data = results["data"] as? [String: Any], let detections = data["detections"] as? [[[String:Any]]] {
                var detectedLanguages = [String]()
                for detection in detections {
                    for currentDetection in detection {
                        if let language = currentDetection["language"] as? String {
                            detectedLanguages.append(language)
                        }
                    }
                }
                if detectedLanguages.count > 0 {
                    self.sourceLanguageCode = detectedLanguages[0]
                    completion(detectedLanguages[0])
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    //MARK - Assigns the results of the HTTP Request using the .detectLanguage TranslationAPI enum parameter to the detectedLanguages array. The correct detectedLanguage is array position [0] is assigned to self.sourceLanguageCode which reflects on the UI to the user.
    
    func fetchSupportedLanguages(completion: @escaping (_ result: Result<[Language], TranslationManagerError>) -> Void) {
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
//        urlParams["target"] = Locale.current.language.languageCode?.identifier ?? "en"
        urlParams["target"] = Locale.current.language.languageCode!.identifier

        
        DispatchQueue.main.async { [self] in
            
            makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: urlParams) { [self] (results) in
                guard let results = results else { completion(.failure(.fetchLanguages)); return }
                
                if let data = results["data"] as? [String: Any], let languages = data["languages"] as? [[String: Any]] {
                    if self.supportedLanguages.isEmpty {
                        
                        for lang in languages {
                            var languageCode: String?
                            var languageName: String?
                            
                            if let code = lang["language"] as? String {
                                languageCode = code
                            }
                            if let name = lang["name"] as? String {
                                languageName = name
                            }
                            if languageName != "" && languageCode != "zh" {
                                self.supportedLanguages.append(Language(name: languageName!, translatorID: languageCode!, id: UUID()))
                            }
                        }
                        self.supportedLanguages.sort()
                        self.isLoading = false
                    }
                } else {
                    completion(.failure(.fetchLanguages))
                    self.isShowingAlert = true
                }
            }
        }
    }
    //MARK - Requests the API to return the supported languages offered by the Cloud Translation API. Results are then converted from a dictionary result into String values and assigned to the supportedLanguage string array.
    
    func translate(completion: @escaping (_ translations: String?) -> Void) {
        guard let textToTranslate = textToTranslate, let targetLanguage = targetLanguageCode else { completion(nil); return }
        
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["q"] = textToTranslate
        urlParams["target"] = targetLanguage
        urlParams["format"] = "text"
        
        if let sourceLanguage = sourceLanguageCode {
            urlParams["source"] = sourceLanguage
            
            makeRequest(usingTranslationAPI: .translate, urlParams: urlParams) { (results) in guard let results = results else {completion(nil); return }
                
                if let data = results["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
                    var allTranslations = [String]()
                    for translation in translations {
                        if let translatedText = translation["translatedText"] as? String {
                            allTranslations.append(translatedText)
                        }
                    }
                    if allTranslations.count > 0 {
                        completion(allTranslations[0])
                    } else {
                        completion(nil)
                    }
                } else {
                    completion (nil)
                    
                }
            }
        }
    }
    //MARK - Requests the API to return a translation using the user's input string. Result is then converted from dictionary result into a string and assigned
    
    func fetchLanguages() {
        if self.hasLoaded == false {
            if !network.isDisconnected {
                
                self.isLoading = true
                
                fetchSupportedLanguages { result in
                    DispatchQueue.main.async {
                        switch result {
                            
                        case .success(let fetchedLanguages):
                            self.supportedLanguages = fetchedLanguages
                            self.isLoading = false
                            self.hasLoaded = true
                        case .failure(_):
                            self.isShowingAlert = true
                        }
                    }
                }
            }
            else {
                isShowingAlert = true
            }
        }
        self.isLoading = false
    }
    //MARK - Checks to make sure device has network connection before requesting the API to fetch languages. If it has connection, it will return the languages. If no connection is available, a boolean value is returned which fires an Alert to the user warning them that the request is not possible at that time.
}

struct Translation {
    var isSeen: Bool = false
}
