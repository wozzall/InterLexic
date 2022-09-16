//
//  CreditsView.swift
//  InterLexic
//
//  Created by George Worrall on 25/07/2022.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/93731716")) { image in
                image.resizable()
                image.cornerRadius(25)
                image.clipShape(Circle())
                image.frame(width: 50, height: 50, alignment: .center)
            } placeholder: {
                ProgressView()
            }
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}
