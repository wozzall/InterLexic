//
//  InputLanguagesSelectorView.swift
//  InterLexic
//
//  Created by George Worrall on 22/11/2022.
//

import SwiftUI

struct LanguageSelectorButtons: View {
    
    @EnvironmentObject var manager: TranslationManager
    
    @ObservedObject var viewModel: TranslatorViewModel
    
    @Binding var languageA: Language
    @Binding var languageB: Language
    @Binding var toFromDirection: Bool
    @Binding var languageDetectionRequired: Bool
    @Binding var hideDetect: Bool
    @Binding var selectedNavigation: String?

    @State var isCardView: Bool
    

    var body: some View {
            HStack {
                Button {
                    viewModel.setDirection(direction: false)
                    didTapSelector(doNotPassOnDetect: isCardView ? true : false)
                } label: {
                    ZStack {
                        Color.offWhite
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
                            .addRoundedBorder(color: .black)
                        if languageA.name.isEmpty {
                            Text("languageSelectorView_from".localized)
                                .padding()
                        }
                        else if languageA.name == "Detecting..." {
                            Text("Detecting...")
                                .foregroundStyle(.blue)
                        }
                        else {
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
                    viewModel.setDirection(direction: true)
                    didTapSelector(doNotPassOnDetect: true)
                } label: {
                    ZStack {
                        Color.offWhite
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
                            .addRoundedBorder(color: .black)
                        if languageB.name == "" {
                            Text("languageSelectorView_to".localized)
                                .padding()
                        }
                        else {
                            Text(languageB.name)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
            .padding(.top, 30)
            .buttonStyle(.borderless)
    }
    
    private func didTapSelector(doNotPassOnDetect: Bool) {
        self.selectedNavigation = nil
        self.hideDetect = doNotPassOnDetect
        self.selectedNavigation = LanguageSelectorView.navigation
    }
}

    
//struct InputLanguagesSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        InputLanguagesSelector()
//    }
//}
