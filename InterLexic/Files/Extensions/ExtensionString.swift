//
//  ExtensionString.swift
//  InterLexic
//
//  Created by George Worrall on 24/06/2022.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
    
    

