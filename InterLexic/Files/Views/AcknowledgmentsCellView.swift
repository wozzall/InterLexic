//
//  AcknowledgmentsCellView.swift
//  InterLexic
//
//  Created by George Worrall on 28/11/2022.
//

import SwiftUI

struct AcknowledgmentsCellView: View {
    
    @State var info: Acknowledgement
    
    var body: some View {
        List {
            Section(header: Text(info.name + " " + (info.version ?? "")).font(.callout)) {
                VStack(alignment: .leading, spacing: 10) {
                    Button {
                        didTapURL(url: info.uRL)
                    } label: {
                        Text(info.uRL)
                    }
                    Divider()
                    Text(info.disclaimer ?? "acknowledgementsView_noDisclaimer".localized)
                        .opacity(0.6)
                }
                .buttonStyle(.borderless)
            }
        }
    }
    /// Sends user to the API Package's URL.
    /// - Parameter url: String describing the desired URL
    func didTapURL(url: String) {
        UIApplication.shared.open(URL(string: url)!)
    }
}
