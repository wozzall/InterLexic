//
//  ExtensionView.swift
//  InterLexic
//
//  Created by George Worrall on 30/06/2022.
//
import SwiftUI
import Foundation

extension View {
    static var navigation: String {
        String(describing: self)
    }
    
    public func addBorder(color: Color) -> some View {
        modifier(AddBorder(color: color))
    }
}
