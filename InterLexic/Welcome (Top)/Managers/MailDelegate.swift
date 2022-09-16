//
//  MailDelegate.swift
//  InterLexic
//
//  Created by George Worrall on 16/09/2022.
//

import Foundation
import MessageUI

class MailDelegate: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    @Published var isShowing = false
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        isShowing = false
    }
}
