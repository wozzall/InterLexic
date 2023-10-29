//
//  InputLanguagesSelectorView.swift
//  InterLexic
//
//  Created by George Worrall on 22/11/2022.
//
//
//import SwiftUI
//
//struct InputLanguagesSelectorView: View {
//    
//    @EnvironmentObject var manager: TranslationManager
//    
//    @ObservedObject var viewModel: TranslatorViewModel
//    
//    @Binding var languageA: Language
//    @Binding var languageB: Language
//    @Binding var toFromDirection: Bool
//    @Binding var languageDetectionRequired: Bool
//
//    @State var selectedNavigation: String?
//    
//    var body: some View {
//        NavigationView {
//            NavigationLink(tag: LanguageSelectorView.navigation, selection: $selectedNavigation) {
//                LanguageSelectorView(languageA: $languageA, languageB: $languageB, toFromDirection: $toFromDirection, languageDetectionRequired: false)
//            } label: {
//                EmptyView()
//            }
//            HStack {
//                Button {
//                    viewModel.setDirection(direction: false)
//                    didTapSelector(isLanguageDetectionRequired: true)
//                } label: {
//                    ZStack {
//                        Color.offWhite
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 15)
//                                    .stroke(.black.opacity(0.5))
//                                    .opacity(0.3)
//                            )
//                        if languageA.name == "" {
//                            Text("languageSelectorView_from".localized)
//                                .padding()
//                        }
//                        else {
//                            Text(languageA.name)
//                                .fixedSize(horizontal: false, vertical: true)
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal)
//                        }
//                    }
//                    .foregroundColor(.blue)
//                }
//                Image(systemName: "arrow.right")
//                    .foregroundColor(.accentColor)
//                Button {
//                    viewModel.setDirection(direction: true)
//                    didTapSelector(isLanguageDetectionRequired: false)
//                } label: {
//                    ZStack {
//                        Color.offWhite
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 2, y: 2)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 15)
//                                    .stroke(.black.opacity(0.5))
//                                    .opacity(0.3)
//                            )
//                        if languageB.name == "" {
//                            Text("languageSelectorView_to".localized)
//                                .padding()
//                        }
//                        else {
//                            Text(languageB.name)
//                                .fixedSize(horizontal: false, vertical: true)
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal)
//                        }
//                    }
//                    .foregroundColor(.blue)
//                }
//            }
//            .frame(height: 50)
//            .padding(.horizontal)
//            .padding(.top, 30)
//            .buttonStyle(.borderless)
//        }
//    }
//        
//    private func didTapSelector(isLanguageDetectionRequired: Bool) {
//        self.selectedNavigation = nil
//        self.languageDetectionRequired = isLanguageDetectionRequired
//        self.selectedNavigation = LanguageSelectorView.navigation
//    }
//}

    
//struct InputLanguagesSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        InputLanguagesSelector()
//    }
//}
