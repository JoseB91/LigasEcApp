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
            
            HStack {
                ShareLink(items: [URL(string: "https://apps.apple.com/tr/app/cleeth/id6472682824")!], subject: Text("Download Cleeth Now!"), message: Text("Hey! Check out this app that helps you remember to brush your teeth!") ,label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Color(.green))
                        Text("Share")
                            .foregroundStyle(Color.primary)
                    }
                })
            }
            
            //                    HStack {
            //                        Button(action: {
            //                            EmailHelper.shared.sendEmail(subject: "Inquiry about Cleeth 🪥", body: "Hello Matias!\nI want to contact you ...", to: "matiasortizluna.contacto@gmail.com", completion: {_ in})
            //                        }, label: {
            //                            HStack {
            //                                Image(systemName: "envelope.badge")
            //                                    .foregroundStyle(Color(.cleethGreen))
            //                                Text("Feedback & Support")
            //                                    .foregroundStyle(Color.primary)
            //                            }
            //                        })
            //                    }
            Section() {
                HStack {
                    Text("App Version")
                    Spacer()
                    Text("1.0(7)")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    SettingsView()
}

