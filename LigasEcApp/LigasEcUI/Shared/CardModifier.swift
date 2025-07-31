//
//  ButtonView.swift
//  LigasEcApp
//
//  Created by José Briones on 31/7/25.
//

import SwiftUI

struct CardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
       
    func body(content: Content) -> some View {
        content
            .padding()
            .background(colorScheme == .dark ? Color(UIColor.systemGray4) : .white)
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
}

extension View {
    var isDarkMode: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }
}
