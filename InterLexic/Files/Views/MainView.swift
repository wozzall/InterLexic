//
//  MainView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var translatorLanguages: SupportedLanguages
    
    @EnvironmentObject var manager: TranslationManager
    
    @State var selection: Int = 1
    @State var hasLoaded: Bool = false
    
    var body: some View {
        TabView(selection: $selection){
            
            TranslatorView(languageA: Language(name: String(), translatorID: String(), id: UUID()), languageB: Language(name: String(), translatorID: String(), id: UUID()))
                .tabItem {
                    Label("TabView_Translate".localized, systemImage: "character.bubble.fill")
                }
                .tag(1)
            
            CardsView(languageA: Language(name: "", translatorID: ""), languageB: Language(name: "", translatorID: ""))
                .tabItem {
                    Label("Flashcards", systemImage: "star.fill")
                }
                .tag(2)
            
            CreditsView()
                .tabItem {
                    Label("Credits".localized, systemImage: "person.crop.circle")
                }
                .tag(3)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(manager)
//    }
//}
