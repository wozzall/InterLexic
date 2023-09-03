//
//  AcknowledgementsMenuView.swift
//  InterLexic
//
//  Created by George Worrall on 31/10/2022.
//

import SwiftUI

struct AcknowledgementsMenuView: View {
    
    var acknowledgements: Array<Acknowledgement>
    
    init() {
        acknowledgements = [
            
            Acknowledgement(id: UUID(), name: "Google Cloud Translate API", uRL: "https://cloud.google.com/translate/", disclaimer: "THIS SERVICE MAY CONTAIN TRANSLATIONS POWERED BY GOOGLE. GOOGLE DISCLAIMS ALL WARRANTIES RELATED TO THE TRANSLATIONS, EXPRESS OR IMPLIED, INCLUDING ANY WARRANTIES OF ACCURACY, RELIABILITY, AND ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT."),
            
            Acknowledgement(id: UUID(), name: "SDWebImageSwiftUI", uRL: "https://github.com/SDWebImage/SDWebImageSwiftUI", version: "2.2.2", disclaimer: """
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
            List {
                Section("settingsView_Licenses".localized) {
                    ForEach(acknowledgements) { acknowledgement in
                        NavigationLink(acknowledgement.name) {
                            AcknowledgmentsCellView(info: acknowledgement)
                        }
                    }
                }
            }
        }
    }


//struct AcknowledgementsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AcknowledgementsMenuView()
//    }
//}
