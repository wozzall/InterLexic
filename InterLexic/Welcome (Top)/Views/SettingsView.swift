//
//  SettingsView.swift
//  InterLexic
//
//  Created by George Worrall on 25/07/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @State var selectedNavigation: String?

    var body: some View {
        NavigationView{
            List {
                Section {
                    NavigationLink(tag: CreditsView.navigation, selection: $selectedNavigation) {
                        CreditsView()
                    } label: {
                        HStack{
                            Text("Settings_Credits".localized)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
