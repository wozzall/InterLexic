//
//  MainView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

import SwiftUI

struct MainView: View {
    
    @State var selection: Int = 1
    
    var body: some View {
        TabView(selection: $selection){
            
            TranslatorView(languageA: Language(name: String(), translatorID: String(), id: UUID()), languageB: Language(name: String(), translatorID: String(), id: UUID()))
                .tabItem {
                    Label("TabView_Translate".localized, systemImage: "character.bubble.fill")
                }
                .tag(1)
                        
            FavouritesView()
                .tabItem {
                    Label("TabView_Favorites".localized, systemImage: "star.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("TabView_Favorites".localized, systemImage: "star.fill")
                }
                .tag(3)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
