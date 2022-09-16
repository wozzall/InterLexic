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
        biography = "Linguist turned iOS Developer. Currently working on iOS App InterLexic and tvOS App Frikanalen."
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    WebImage(url: URL(string: "https://avatars.githubusercontent.com/u/93731716"))
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                        .clipShape(Circle())
                        .padding()
                }
                Spacer()
                ZStack {
                    Color.offWhite
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    Text(biography)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                Spacer()
                HStack{
                    Button {
                        didTapGitHub()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color.offWhite)
                                .shadow(color: .gray, radius: 2, x: 1, y: 1)
                            Text("GitHub")
                                .padding()
                        }
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        didTapLinkedIn()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color.offWhite)
                                .shadow(color: .gray, radius: 2, x: 1, y: 1)
                            Text("LinkedIn")
                                .padding()
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        didTapGitHub()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color.offWhite)
                                .shadow(color: .gray, radius: 2, x: 1, y: 1)
                            Image(systemName: "envelope.fill")
                                .padding()
                        }
                    }
                }
                .padding()
            }
        }
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
