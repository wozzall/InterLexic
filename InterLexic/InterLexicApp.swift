//
//  InterLexicApp.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI

class LanguageSelection: ObservableObject {
   @Published var languageA: Language?
   @Published var languageB: Language?
    
}

@main
struct InterLexicApp: App {
    
    @StateObject var selection = LanguageSelection()
    
    var body: some Scene {
        WindowGroup {
            TranslatorView()
                .environmentObject(selection)
        }
    }
}
