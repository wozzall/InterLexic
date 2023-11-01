//
//  SwiftUIView.swift
//  InterLexic
//
//  Created by George Worrall on 14/11/2022.
//

import SwiftUI
import Foundation
import AVFoundation

struct CardsView: View {
    
    @EnvironmentObject var flashCardStorage: FlashCardStorage
    @EnvironmentObject var manager: TranslationManager
    @ObservedObject var viewModel = TranslatorViewModel()
    @ObservedObject var textToSpeech = TextToSpeech()
    @State var synthesizer = AVSpeechSynthesizer()
    @State var languageA: Language = Language(name: "", translatorID: "")
    @State var languageB: Language = Language(name: "", translatorID: "")
    @State var hasLoaded: Bool = false
    @State var toFromDirection: Bool = false
    // MARK - True = to, False = from
    @State var selectedNavigation: String?
    @State var tapDelete: Bool = false
    @State var animationAmount = 1.0
    @State var tapFilter: Bool = false
    @State var languageDetectionRequired: Bool = false
    @State var hideDetect: Bool = true
    
    @State var filteredFlashCards: Array<FlashCard> = []
    
    
    
    var body: some View {
        NavigationView {
            ScrollView{
                NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                    LanguageSelectorView(languageA: $languageA, languageB: $languageB, toFromDirection: $viewModel.toFromDirection, languageDetectionRequired: $languageDetectionRequired, hideDetectButton: hideDetect)
                } label: {
                    EmptyView()
                }
                //MARK - Flashcard
                if tapFilter{
                    LanguageSelectorButtons(viewModel: viewModel, languageA: $languageA, languageB: $languageB, toFromDirection: $viewModel.toFromDirection, languageDetectionRequired: $languageDetectionRequired, hideDetect: $hideDetect, selectedNavigation: $selectedNavigation, isCardView: true)
                }
                if flashCardStorage.flashCards.isEmpty {
                    Spacer()
                    VStack(alignment: .center){
                        Spacer()
                        Text("cardsView_noTranslationsSaved".localized)
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .foregroundColor(.red.opacity(0.7))
                            .padding()

                        HStack {
                            Text("cardsView_tap".localized)
                            Image(systemName: "character.bubble.fill")
                            Text("cardsView_tapFinish".localized)
                        }
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.8))
                        Spacer()

                    }
                    .frame(maxWidth: .infinity)
                    
                } else if filteredFlashCards.isEmpty {
                    VStack{
                        Spacer()
                        Text("cardsView_noCards".localized)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .font(.body)
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                
                else {
                        LazyVStack{
                            ForEach(filteredFlashCards, id: \.id) { flashCard in
                                Section("") {
                                    FlashCardView(synthesizer: $synthesizer, flashCard: flashCard)
                                        .overlay(alignment: .topTrailing) {
                                            if tapDelete {
                                                Button {
                                                    flashCardStorage.removeCard(selectedCard: flashCard)
                                                } label: {
                                                    ZStack{
                                                        Image(systemName: "minus.circle.fill")
                                                            .resizable()
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
                                            }
                                        }
                                        .padding(.horizontal, 50)
                                }
                                .padding()
                                
                            }
                        }
//                        .environment(\.defaultMinListRowHeight, 50)
                        .onChange(of: flashCardStorage.flashCards) { _ in
                            filterFlashCards()
                        }
//                    }
//                    .toolbar {
//                        ToolbarItemGroup(placement: .automatic) {
//                            Button {
//                                tapFilter.toggle()
//                            } label: {
//                                if tapFilter {
//                                    Text("cardsView_hideFilterButton".localized)
//                                } else {
//                                    Text("cardsView_filterButton".localized)
//                                }
//                            }
//                            if tapFilter {
//                                Button("cardsView_clearFilterButton".localized) {
//                                    languageA = didTapClear()
//                                    languageB = didTapClear()
//                                }
//                            }
//                            Button {
//                                tapDelete.toggle()
//                            } label: {
//                                if tapDelete == false {
//                                    Text("cardsView_deleteButton".localized)
//                                        .foregroundColor(.red)
//                                } else {
//                                    Text("cardsView_cancelButton".localized)
//                                        .foregroundColor(.red)
//                                    
//                                }
//                            }
//                        }
//                    }
//                    .background(Color.offWhite.opacity(0.7))
                }
            }
            .background(Color.offWhite.opacity(0.7))
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        tapFilter.toggle()
                    } label: {
                        if tapFilter {
                            Text("cardsView_hideFilterButton".localized)
                        } else {
                            Text("cardsView_filterButton".localized)
                        }
                    }
                    if tapFilter {
                        Button("cardsView_clearFilterButton".localized) {
                            languageA = didTapClear()
                            languageB = didTapClear()
                        }
                    }
                    Button {
                        tapDelete.toggle()
                    } label: {
                        if tapDelete == false {
                            Text("cardsView_deleteButton".localized)
                                .foregroundColor(.red)
                        } else {
                            Text("cardsView_cancelButton".localized)
                                .foregroundColor(.red)
                            
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
        .navigationTitle(Text("tabView_flashCards".localized))
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
                self.filteredFlashCards.removeAll { $0.sourceLanguage.name != languageA.name }
            }
            
            if languageA.name.isEmpty && !languageB.name.isEmpty {
                self.filteredFlashCards.removeAll { $0.targetLanguage.name != languageB.name}
            }
            
            if !languageA.name.isEmpty && !languageB.name.isEmpty {
                self.filteredFlashCards.removeAll { ($0.sourceLanguage.name + $0.targetLanguage.name) != (languageA.name + languageB.name)}
            }
        }
    }
}




//struct CardsTESTView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
