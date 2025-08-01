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
            //                    NavigationLink(destination: PrivacyPolicyView()) {
            //                        HStack {
            //                            Image(systemName: "person.crop.circle")
            //                                .foregroundStyle(Color(.green))
            //                            Text("Privacy Policy")
            //                        }
            //                        .foregroundStyle(Color.primary)
            //                    }
                        
//            HStack {
//                Button(action: {
//                    EmailHelper.shared.sendEmail(subject: "Inquiry about Cleeth 🪥",
//                                                 body: "Hello Matias!\nI want to contact you ...",
//                                                 to: "matiasortizluna.contacto@gmail.com", completion: {_ in})
//                }, label: {
//                    HStack {
//                        Image(systemName: "envelope.badge")
//                        Text("Feedback & Support")
//                            .foregroundStyle(Color.primary)
//                    }
//                })
//            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    SettingsView()
}
