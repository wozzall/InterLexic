//
//  InterLexicApp.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI

@main
struct InterLexicApp: App {
    
    @StateObject var flashCardStorage = FlashCardStorage()
    @StateObject var networkMonitor = Monitor()
    @StateObject var translatorLanguages = SupportedLanguages()

    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(flashCardStorage)
                .environmentObject(translatorLanguages)
                .environmentObject(networkMonitor)
            
        }
    }
}
