//
//  CreditsView.swift
//  InterLexic
//
//  Created by George Worrall on 25/07/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import MessageUI


struct CreditsView: View {
    
    private var biography: String
    
    @ObservedObject var mailDelegate = MailDelegate()
    
    @State var presentingAlert = false
    
    init() {
        biography = "Linguist turned iOS Developer.\n Currently working on iOS App InterLexic and tvOS App Frikanalen."
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                WebImage(url: URL(string: "https://avatars.githubusercontent.com/u/93731716"))
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .clipShape(Circle())
                    .padding()
                    .shadow(color: .gray, radius: 2, x: 1, y: 1)
            }
            Text("George Worrall")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .padding()
            Text(biography)
                .multilineTextAlignment(.center)
                .padding()
                .fixedSize(horizontal: false, vertical: true)
            
            HStack{
                Button {
                    didTapGitHub()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.offWhite)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        Text("GitHub")
                    }
                }
            
                Button {
                    didTapLinkedIn()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.offWhite)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        Text("LinkedIn")
                    }
                }

                Button {
                    didTapMail()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.offWhite)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        Image(systemName: "envelope.fill")
                    }
                }

            }
            .frame(height: 50)
            .padding()
            Spacer()
        }
        .background(
            Color.gray
                .opacity(0.2)
        )
    }
    
    func didTapGitHub() {
        UIApplication.shared.open(URL(string: "https://github.com/wozzall")!)
    }
    
    func didTapLinkedIn() {
        UIApplication.shared.open(URL(string: "https://www.linkedin.com/in/georgeworrall/")!)
    }
    
    func didTapMail() {
        //
        //        if MFMailComposeViewController.canSendMail() {
        //
        //            let mail = MFMailComposeViewController()
        //            mail.mailComposeDelegate = mailDelegate
        //            mail.setToRecipients([])
        //            viewControllerHolder?.present(mail, animated: true) {
        //
        //                mailDelegate.isShowing = true
        //            }
        //        }
        //        else {
        //
        //            presentingAlert = true
        //        }
        //    }
    }
}


struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}
