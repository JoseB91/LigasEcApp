//
//  SettingsView.swift
//  LigasEcApp
//
//  Created by José Briones on 12/6/25.
//

import SwiftUI

struct SettingsView: View {

    var body: some View {
        List {
            NavigationLink("Privacy Policy") { //TODO: Add constants
                if let url = Bundle.main.url(forResource: "LigasEc_PrivacyPolicy", withExtension: "pdf") {
                    PDFViewer(url: url)
                        .navigationTitle("PDF Viewer")
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text("PDF not found")
                }
            }
            Section {
                Button(action: openMailApp) {
                    Label("Send Email", systemImage: "envelope") //TODO: Add constants
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }

    private func openMailApp() {
        let email = "jose.briones.r@hotmail.com"
        let subject = "App Support Request" //TODO: Add constants
        let body = "Hi there,\n\n" //TODO: Add constants
        
        let urlString = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
