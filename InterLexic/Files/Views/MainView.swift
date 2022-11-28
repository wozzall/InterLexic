//
//  MainView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var translatorLanguages: SupportedLanguages
    
    @ObservedObject var manager: TranslationManager
    
    @State var selection: Int = 1
    @State var hasLoaded: Bool = false
    
    var body: some View {
        TabView(selection: $selection){
            
            TranslatorView(languageA: Language(name: String(), translatorID: String(), id: UUID()), languageB: Language(name: String(), translatorID: String(), id: UUID()))
                .tabItem {
                    Label("TabView_Translate".localized, systemImage: "character.bubble.fill")
                }
                .tag(1)
            
//            FlashCardDeckView()
//                .tabItem {
//                    Label("TabView_Favorites".localized, systemImage: "star.fill")
//                }
//                .tag(2)
            
            CardsTESTView(languageA: Language(name: "", translatorID: ""), languageB: Language(name: "", translatorID: ""))
                .tabItem {
                    Label("FC Test", systemImage: "star.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("TabView_Settings".localized, systemImage: "gear")
                }
                .tag(3)
        }
        .onAppear(perform: languagesFetchSetup)
        
    }
    
    func languagesFetchSetup() {
        if !hasLoaded {
            manager.fetchLanguage()
            if self.translatorLanguages.languages.isEmpty {
                for language in manager.supportedLanguages {
                    self.translatorLanguages.add(language)
                }
                self.translatorLanguages.languages = Array(Set(translatorLanguages.languages)).sorted()
            }
            hasLoaded = true
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(manager)
//    }
//}
