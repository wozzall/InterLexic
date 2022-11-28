//
//  InputLanguagesSelectorView.swift
//  InterLexic
//
//  Created by George Worrall on 22/11/2022.
//

import SwiftUI

struct InputLanguagesSelectorView: View {
    
    @EnvironmentObject var manager: TranslationManager
    
    @Binding var languageA: Language
    @Binding var languageB: Language
    @Binding var toFromDirection: Bool
    @Binding var sourceLanguageState: SelectorState
    @Binding var targetLanguageState: SelectorState
    @State var selectedNavigation: String?
    
    var body: some View {
        NavigationView {
            NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
                LanguageSelectorView(manager: manager, languageA: $languageA, languageB: $languageB, toFromDirection: $toFromDirection)
            } label: {
                EmptyView()
            }
            HStack {
                Button {
                    didTapSelector()
                    sourceLanguageState = .selected
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
                    didTapSelector()
                    targetLanguageState = .selected
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
        }
    }
        
    private func didTapSelector() {
        self.selectedNavigation = nil
        self.selectedNavigation = LanguageSelectorView.navigation
    }
}

    
//struct InputLanguagesSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        InputLanguagesSelector()
//    }
//}
