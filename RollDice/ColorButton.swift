//
//  ColorButton.swift
//  RollDice
//
//  Created by Marjo Salo on 22/07/2021.
//

import SwiftUI

struct ColorButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 6.0))
            .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color.gray, lineWidth: 1))
            .shadow(color: .gray, radius: 2)
    }
}

extension View {
    func colorButton() -> some View {
        self.modifier(ColorButton())
    }
}
