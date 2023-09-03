//
//  SplashScreenView.swift
//  InterLexic
//
//  Created by George Worrall on 09/08/2022.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State var hasLoaded: Bool = false
    @State var isActive = false
    @State var size = 0.8
    @State var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainView()
        }
        else {
            VStack{
                Image(uiImage: UIImage(named: "SplashScreenIcon") ?? UIImage())
                    .resizable()
                    .frame(width: 200, height: 200)
                Text("SplashScreenView_Interlexic".localized)
                    .foregroundColor(.black)
                    .font(.system(.largeTitle, design: .rounded)
                        .weight(.bold).lowercaseSmallCaps())
                    .padding(.bottom)
                Text("SplashScreenView_Name".localized)
                    .foregroundColor(.gray)
                    .opacity(0.7)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
        }
    }
}
//
//struct SplashScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashScreenView()
//    }
//}
