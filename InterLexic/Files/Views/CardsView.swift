//
//  SwiftUIView.swift
//  InterLexic
//
//  Created by George Worrall on 14/11/2022.
//

import SwiftUI
import Foundation


struct CardsView: View {
    
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    @EnvironmentObject var manager: TranslationManager
        
    @State var languageA: Language
    @State var languageB: Language
    @State var hasLoaded: Bool = false
    @State var toFromDirection: Bool = false
    // MARK - True = to, False = from
    @State var selectedNavigation: String?
    @State var filteredFlashCards: Array<FlashCard> = []
    
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                    LanguageSelectorView(languageA: $languageA, languageB: $languageB, toFromDirection: $toFromDirection)
                } label: {
                    EmptyView()
                }
                // MARK - Language Selectors
                HStack {
                    Button {
                        toFromDirection = false
                        didTapSelector()
                    } label: {
                        ZStack {
                            Color.offWhite
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                            if languageA.name.isEmpty {
                                Text("languageSelectors_chooseLanguage".localized)
                                    .padding()
                            } else {
                                Text(languageA.name)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    Image(systemName: "arrow.right")
                        .foregroundColor(.accentColor)
                    Button {
                        toFromDirection = true
                        didTapSelector()
                    } label: {
                        ZStack {
                            Color.offWhite
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                            if languageB.name.isEmpty {
                                Text("languageSelectors_chooseLanguage".localized)
                                    .padding()
                            }
                            Text(languageB.name)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .foregroundColor(.blue)
                    }
                }
                .frame(height: 50)
                .padding()
                .buttonStyle(.borderless)
                //MARK - Flashcards
                if flashCardStorage.flashCards.isEmpty {
                    VStack{
                        Text("No flashcards saved. Please save translations to create flashcards!")
                    }
                }
                else {
                    List{
                        ForEach(filteredFlashCards, id: \.id) { flashCard in
                            Section("") {
                                FlashCardView(flashCard: flashCard)
                                    .padding(.leading, 25)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .environment(\.defaultMinListRowHeight, 50)
                    .listStyle(.insetGrouped)
                    .listRowSeparator(.hidden)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button("Clear Languages") {
                        languageA = didTapClear()
                        languageB = didTapClear()
                    }
                    EditButton()
                }
                    
            }
            .onAppear(perform: filterFlashCards)
            .onChange(of: languageA) { _ in
                filterFlashCards()
            }
            .onChange(of: languageB) { _ in
                filterFlashCards()
            }
            .onChange(of: filteredFlashCards) { _ in
                filterFlashCards()
            }
        }
        .navigationTitle(Text("Flashcards"))
    }
    
    private func didTapSelector() {
        self.selectedNavigation = nil
        self.selectedNavigation = LanguageSelectorView.navigation
    }
    
    private func didTapClear() -> Language {
        let clearedLanguage = Language(name: "", translatorID: "")
        return clearedLanguage
    }
    
    func filterFlashCards() {
               
        self.filteredFlashCards = flashCardStorage.flashCards.sorted()
        print(flashCardStorage.flashCards)
        print(filteredFlashCards)
        withAnimation {
            if !languageA.name.isEmpty && languageB.name.isEmpty {
                self.filteredFlashCards.removeAll { $0.sourceLanguage != languageA.name }
            }
            
            if languageA.name.isEmpty && !languageB.name.isEmpty {
                self.filteredFlashCards.removeAll { $0.targetLanguage != languageB.name}
            }
            
            if !languageA.name.isEmpty && !languageB.name.isEmpty {
                self.filteredFlashCards.removeAll { ($0.sourceLanguage + $0.targetLanguage) != (languageA.name + languageB.name)}
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        withAnimation {
            for offset in offsets{
                if let index = flashCardStorage.flashCards.firstIndex(of: filteredFlashCards[offset]) {
                    flashCardStorage.removeCard(at: index)
                }
            }
        }
    }
}




//struct CardsTESTView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
