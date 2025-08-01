//
//  ErrorAlertModifier.swift
//  LigasEcApp
//
//  Created by José Briones on 31/7/25.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var errorModel: ErrorModel?
    
    func body(content: Content) -> some View {
        content
            .alert(item: $errorModel) { error in
                Alert(
                    title: Text(Constants.error),
                    message: Text(error.message),
                    dismissButton: .default(Text(Constants.ok))
                )
            }
    }
}

extension View {
    func withErrorAlert(errorModel: Binding<ErrorModel?>) -> some View {
        self.modifier(ErrorAlertModifier(errorModel: errorModel))
    }
}
