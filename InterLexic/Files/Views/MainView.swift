//
//  MainView.swift
//  InterLexic
//
//  Created by George Worrall on 12/07/2022.
//

import SwiftUI

struct MainView: View {
        
    @EnvironmentObject var manager: TranslationManager
    
    @State var selection: Int = 1
    @State var hasLoaded: Bool = false
    
    var body: some View {
        TabView(selection: $selection){
            TranslatorView()
                .tabItem {
                    Label("tabView_translate".localized, systemImage: "character.bubble.fill")
                }
                .tag(1)
            CardsView()
                .tabItem {
                    Label("tabView_flashCards".localized, systemImage: "star.fill")
                }
                .tag(2)
            AboutView()
                .tabItem {
                    Label("tabView_about".localized, systemImage: "questionmark.circle")
                }
                .tag(3)
        }
        .edgesIgnoringSafeArea(.top)
    }
}
