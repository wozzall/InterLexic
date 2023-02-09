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
    
    private var acknowledgements: Array<Acknowledgement>
    
    @State var presentingAlert = false
    
    @State private var mailData = ComposeMailData(subject: "",
                                                  recipients: ["wozzall.ios@gmail.com"],
                                                  message: "Sent from within Interlexic app. Please write your message below.")
    
    @State private var showMailView = false
    
    @State private var canSendMail = MailViewRepresentative.canSendMail

    
    init() {
        biography = "Linguist turned iOS Developer.\n Currently working on iOS App InterLexic and tvOS App Frikanalen."
        acknowledgements = [
                
                Acknowledgement(id: UUID(), name: "Google Cloud Translate API", uRL: "https://cloud.google.com/translate/", disclaimer: "THIS SERVICE MAY CONTAIN TRANSLATIONS POWERED BY GOOGLE. GOOGLE DISCLAIMS ALL WARRANTIES RELATED TO THE TRANSLATIONS, EXPRESS OR IMPLIED, INCLUDING ANY WARRANTIES OF ACCURACY, RELIABILITY, AND ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT."),
                
                Acknowledgement(id: UUID(), name: "SDWebImageSwiftUI", uRL: "https://github.com/SDWebImage/SDWebImageSwiftUI", version: "2.2.1", disclaimer: """
                                Copyright (c) 2019 lizhuoli1126@126.com <lizhuoli1126@126.com>
                                
                                Permission is hereby granted, free of charge, to any person obtaining a copy
                                of this software and associated documentation files (the "Software"), to deal
                                in the Software without restriction, including without limitation the rights
                                to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                                copies of the Software, and to permit persons to whom the Software is
                                furnished to do so, subject to the following conditions:
                                
                                The above copyright notice and this permission notice shall be included in
                                all copies or substantial portions of the Software.
                                
                                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                                IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                                FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                                AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                                LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                                OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
                                THE SOFTWARE.
                                """),
                
                Acknowledgement(id: UUID(), name: "ToastSwiftUI", uRL: "https://github.com/huynguyencong/ToastSwiftUI", version: "0.3.4", disclaimer: """
                                MIT License
                                
                                Copyright (c) 2020 Huy Nguyen
                                
                                Permission is hereby granted, free of charge, to any person obtaining a copy
                                of this software and associated documentation files (the "Software"), to deal
                                in the Software without restriction, including without limitation the rights
                                to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                                copies of the Software, and to permit persons to whom the Software is
                                furnished to do so, subject to the following conditions:
                                
                                The above copyright notice and this permission notice shall be included in all
                                copies or substantial portions of the Software.
                                
                                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                                IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                                FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                                AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                                LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                                OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                                SOFTWARE.
                                """)
            ]
    }
    
    var body: some View {
        NavigationView{
            List{
                Section("Profile") {
                    VStack(spacing: 5) {
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
                        
                        HStack(spacing: 40){
                            Spacer()
                            Button {
                                didTapGitHub()
                            } label: {
                                HStack(spacing: 0){
                                    Image("github-mark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 35, height: 35)
                                        .clipped()
                                    Image("GitHub_Logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 25)
                                        .clipped()
                                }
                            }
                            .buttonStyle(.borderless)
                            
                            Button {
                                didTapLinkedIn()
                            } label: {
                                    Image("LI-In-Bug")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                            }
                            .buttonStyle(.borderless)
                            
                            Button {
                                if canSendMail {
                                    showMailView.toggle();
                                } else {
                                    presentingAlert = true
                                }
                            } label: {
                                HStack(spacing: 0){
                                    Image(systemName: "envelope.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                }

                            }
                            .buttonStyle(.borderless)
                            .padding(.leading)
                            Spacer()
                            .sheet(isPresented: $showMailView) {
                                MailViewRepresentative(data: $mailData) { result in
                                    print(result)
                                }
                            }
                            .alert(isPresented: $presentingAlert) {
                                Alert(title: Text("Error!"), message: Text("There is no mail client setup on this device. Please set up email and try again!"), dismissButton: .default(Text("Dismiss")))
                            }
                        }
                        .frame(height: 50)
                        .padding()
                        
                    }
                }
                
                Section("Acknowledgements") {
                    ForEach(acknowledgements) { acknowledgement in
                        NavigationLink(acknowledgement.name) {
                            AcknowledgmentsCellView(info: acknowledgement)
                        }
                    }
                }
            }
        }
        .background(
            Color.gray
                .opacity(0.1)
        )
        
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
