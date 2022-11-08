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
                    showMailView.toggle();
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.offWhite)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        Image(systemName: "envelope.fill")
                    }
                }
                .disabled(!MailViewRepresentative.canSendMail)
                .sheet(isPresented: $showMailView) {
                    MailViewRepresentative(data: $mailData) { result in
                        print(result)
                    }
                }
                

            }
            .frame(height: 50)
            .padding()
            HStack(alignment: .center) {
                if !MailViewRepresentative.canSendMail {
                    Text("Unable to send email because mail is not setup on this device.")
                        .opacity(0.5)
                }
            }
            Spacer()
        }
        .background(
            Color.gray
                .opacity(0.2)
        )
        .alert(isPresented: $canSendMail) {
            Alert(title: Text("Error!"), message: Text("There is no mail client setup on this device."), dismissButton: .default(Text("Cancel")))
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
