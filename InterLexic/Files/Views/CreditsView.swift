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
    
    @Environment(\.openURL) private var openURL
            
    private var biography: String
        
    @State var presentingAlert = false
    
    @State private var mailData = ComposeMailData(subject: "",
                                                  recipients: ["wozzall.ios@gmail.com"],
                                                  message: "Sent from within Interlexic app. Please write your message below.")
    
    @State private var showMailView = false
    
    @State private var canSendMail = MailViewRepresentative.canSendMail

    
    init() {
        biography = "Linguist turned iOS Developer.\n Currently working on iOS App InterLexic and tvOS App Frikanalen."
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            WebImage(url: URL(string: "https://avatars.githubusercontent.com/u/93731716"))
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 2, x: 1, y: 1)
                .padding()
            Text("George Worrall")
                .multilineTextAlignment(.center)
                .font(.title)
            Text(biography)
                .multilineTextAlignment(.center)
                .padding()
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 35){
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
                    if canSendMail {
                        showMailView.toggle();
                    } else {
                        presentingAlert = true
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.offWhite)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        Image(systemName: "envelope.fill")
                    }
                }
                .sheet(isPresented: $showMailView) {
                    MailViewRepresentative(data: $mailData) { result in
                        print(result)
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
        .alert(isPresented: $presentingAlert) {
            Alert(title: Text("Error!"), message: Text("There is no mail client setup on this device. Please set up email and try again!"), dismissButton: .default(Text("Dismiss")))
        }
    }
    
    func didTapGitHub() {
        UIApplication.shared.open(URL(string: "https://github.com/wozzall")!)
    }
    
    func didTapLinkedIn() {
        UIApplication.shared.open(URL(string: "https://www.linkedin.com/in/georgeworrall/")!)
    }
}


struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}
