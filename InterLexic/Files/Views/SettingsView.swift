//
//  SettingsView.swift
//  InterLexic
//
//  Created by George Worrall on 25/07/2022.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @State var selectedNavigation: String?
    
    var body: some View {
        NavigationView{
            List {
                Section(header: Text("Settings_section_acknowledgements".localized)) {
                    NavigationLink(tag: AboutView.navigation, selection: $selectedNavigation) {
                        AboutView()
                    } label: {
                        HStack{
                            Text("Settings_Credits".localized)
                        }
                    }
                    NavigationLink(tag: AcknowledgementsMenuView.navigation, selection: $selectedNavigation) {
                        AcknowledgementsMenuView()
                    } label: {
                        HStack{
                            Text("Licenses")
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
