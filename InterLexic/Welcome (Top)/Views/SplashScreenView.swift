//
//  SplashScreenView.swift
//  InterLexic
//
//  Created by George Worrall on 09/08/2022.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State var isActive = false
    @State var size = 0.8
    @State var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainView()
        }
        else {
            VStack{
                VStack{
                    Image(uiImage: UIImage(named: "SplashScreenIcon") ?? UIImage())
                        .resizable()
                        .frame(width: 200, height: 200)
                    Text("InterLexic")
                    .foregroundColor(.black)
                    .font(.system(.largeTitle, design: .rounded)
                        .weight(.bold).lowercaseSmallCaps())
                    .padding(.bottom)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
