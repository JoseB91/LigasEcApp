//
//  SettingsView.swift
//  LigasEcApp
//
//  Created by José Briones on 12/6/25.
//

import SwiftUI

struct SettingsView: View {

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        List {
            NavigationLink {
                if let url = Bundle.main.url(forResource: "LigasEc_PrivacyPolicy", withExtension: "pdf") {
                    PDFViewer(url: url)
                        .navigationTitle(Constants.pdfViewer)
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text(Constants.pdfNotFound)
                }
            } label: {
                Label(Constants.privacyPolicy, systemImage: "doc.text")
            }
            Button(action: openMailApp) {
                Label(Constants.sendEmail, systemImage: "envelope")
            }
            .buttonStyle(PlainButtonStyle())

            HStack {
                Label(Constants.appVersion, systemImage: "info.circle")
                Spacer()
                Text(appVersion)
                    .foregroundColor(.secondary)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Constants.settings)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func openMailApp() {
        let email = "jose.briones.r@hotmail.com"
        let subject = String(localized: "CONTACT_SUBJECT")
        let body = String(localized: "CONTACT_BODY")
        
        let urlString = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
