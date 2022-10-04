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
//    @StateObject var supportedLanguages = TranslatorLanguages()
    @StateObject var networkMonitor = Monitor()

    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(flashCardStorage)
//                .environmentObject(supportedLanguages)
                .environmentObject(networkMonitor)
        }
    }
}
