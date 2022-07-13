//
//  InterLexicApp.swift
//  InterLexic
//
//  Created by George Worrall on 05/04/2022.
//

import SwiftUI

@main
struct InterLexicApp: App {
    
    @StateObject var favorites = Favorites()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(favorites)
        }
    }
}
