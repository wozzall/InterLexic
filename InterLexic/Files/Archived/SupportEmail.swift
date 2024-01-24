//
//  SupportEmail.swift
//  InterLexic
//
//  Created by George Worrall on 31/10/2022.
//

import UIKit
import SwiftUI

struct SupportEmail {
    let toAddress: String
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)"
        
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                """
                )
            }
        }
    }
}
