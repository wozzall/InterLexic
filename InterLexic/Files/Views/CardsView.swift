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
    @State var hitEdit: Bool = false
    @State var animationAmount = 1.0
    
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                    LanguageSelectorView(languageA: $languageA, languageB: $languageB, toFromDirection: $toFromDirection)
                } label: {
                    EmptyView()
                }
                // MARK - Language Selectors
                //                HStack{
                //                    Text("Filter by:")
                //                        .padding(.horizontal)
                //                    Spacer()
                //                }
                
                ZStack{
                    //MARK - Flashcards
                    if filteredFlashCards.isEmpty {
                        VStack{
                            Spacer()
                            Text("There are either no cards that match your filter query, or no flashcards saved. Please save translations to create flashcards!")
                                .padding()
                            Spacer()
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.blue)
                                    .frame(height: 50)
                                    .padding(.horizontal, 45)
                                    .opacity(0.5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.blue, lineWidth: 4)
                                            .padding(.horizontal, 45)
                                    )
                                HStack{
                                    Image(systemName: "arrow.turn.left.down")
                                        .font(.body)
                                        .padding(.leading, 50)
                                    Text("Tap here to start translating!")
                                        .padding(.bottom, 15)
                                    Spacer()
                                }
                            }
                            .opacity(0.7)
                            .padding(.bottom)
                            .padding(.trailing)
                        }
                    }
                    else {
                        ScrollView {
                            Spacer()
                                .frame(height: 90)
                            LazyVStack{
                                ForEach(filteredFlashCards, id: \.id) { flashCard in
                                    Section("") {
                                        FlashCardView(flashCard: flashCard)
                                            .overlay(alignment: .topTrailing) {
                                                if hitEdit {
                                                    Button {
                                                        flashCardStorage.removeCard(selectedCard: flashCard)
                                                    } label: {
                                                        ZStack{
                                                            Circle()
                                                                .strokeBorder(Color.red)
                                                                .frame(width: 25, height: 25)
                                                                .opacity(0.8)
                                                            Image(systemName: "trash.fill")
                                                                .foregroundColor(Color.red)
                                                                .frame(width: 25, height: 25)
                                                                .opacity(0.8)
                                                                .animation(.easeIn(duration: 2)
                                                                    .repeatForever(autoreverses: false),
                                                                           value: animationAmount)
                                                        }
                                                        .padding(.trailing, 4)
                                                        .padding(.top, 4)
                                                    }
                                                } else {
                                                    EmptyView()
                                                }
                                            }
                                            .padding(.horizontal, 50)
                                    }
                                }
                            }
                            .environment(\.defaultMinListRowHeight, 50)
                            .onChange(of: flashCardStorage.flashCards) { _ in
                                filterFlashCards()
                            }
                        }
                    }
                    VStack{
                        ZStack{
                            Color.clear.opacity(0.3)
                                .background(.ultraThinMaterial)
                                .saturation(0.0)
                                .frame(height: 90)
                            HStack{
                                Button {
                                    toFromDirection = false
                                    didTapSelector()
                                } label: {
                                    ZStack {
                                        Color.offWhite
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(.black)
                                                    .opacity(0.3)
                                            )
                                        if languageA.name.isEmpty {
                                            Text("languageSelectors_from".localized)
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
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(.black)
                                                    .opacity(0.3)
                                            )
                                        if languageB.name.isEmpty {
                                            Text("languageSelectors_to".localized)
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
                        }
                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button("Clear Filters") {
                        languageA = didTapClear()
                        languageB = didTapClear()
                    }
                    Button {
                        hitEdit.toggle()
                    } label: {
                        if hitEdit == false {
                            Text("Delete")
                        } else {
                            Text("Cancel")
                        }
                    }
                }
            }
            .onAppear{
                filterFlashCards()
                animationAmount = 2
            }
            .onChange(of: languageA) { _ in
                filterFlashCards()
            }
            .onChange(of: languageB) { _ in
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
    
    //    func deleteItems(at offsets: IndexSet) {
    //        withAnimation {
//            for offset in offsets{
//                if let index = flashCardStorage.flashCards.firstIndex(of: filteredFlashCards[offset]) {
//                    flashCardStorage.removeCard(at: index)
//                }
//            }
//        }
//    }
}




//struct CardsTESTView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
