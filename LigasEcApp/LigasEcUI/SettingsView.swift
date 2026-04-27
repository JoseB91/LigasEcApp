//
//  SettingsView.swift
//  LigasEcApp
//
//  Created by José Briones on 12/6/25.
//

import MessageUI
import SwiftUI

struct SettingsView: View {
    @State private var errorModel: ErrorModel?
    @State private var isShowingMailComposer = false

    private let emailRecipient = "jose.briones.r@hotmail.com"

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    private var emailSubject: String {
        String(localized: "CONTACT_SUBJECT")
    }

    private var emailBody: String {
        String(localized: "CONTACT_BODY")
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
            .accessibilityHint(Constants.opensPrivacyPolicy)

            Button(action: openMailApp) {
                Label(Constants.contactSupport, systemImage: "envelope")
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityHint(Constants.opensEmailClient)

            HStack {
                Label(Constants.appVersion, systemImage: "info.circle")
                Spacer()
                Text(appVersion)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(String(localized: "CURRENT_VERSION", defaultValue: "Current version: \(appVersion)"))
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Constants.settings)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $isShowingMailComposer) {
            MailComposeView(
                recipient: emailRecipient,
                subject: emailSubject,
                body: emailBody
            ) { result in
                if case let .failure(error) = result {
                    errorModel = ErrorModel(message: error.localizedDescription)
                }
            }
        }
        .withErrorAlert(errorModel: $errorModel)
    }

    private func openMailApp() {
        if MFMailComposeViewController.canSendMail() {
            isShowingMailComposer = true
            return
        }

        guard
            let url = mailtoURL(),
            UIApplication.shared.canOpenURL(url)
        else {
            errorModel = ErrorModel(message: String(localized: "MAIL_UNAVAILABLE"))
            return
        }

        UIApplication.shared.open(url)
    }

    private func mailtoURL() -> URL? {
        let subject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "mailto:\(emailRecipient)?subject=\(subject)&body=\(body)")
    }
}

private struct MailComposeView: UIViewControllerRepresentable {
    let recipient: String
    let subject: String
    let body: String
    let onFinish: (Result<MFMailComposeResult, Error>) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onFinish: onFinish)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setToRecipients([recipient])
        controller.setSubject(subject)
        controller.setMessageBody(body, isHTML: false)
        controller.mailComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let onFinish: (Result<MFMailComposeResult, Error>) -> Void

        init(onFinish: @escaping (Result<MFMailComposeResult, Error>) -> Void) {
            self.onFinish = onFinish
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            controller.dismiss(animated: true)

            if let error {
                onFinish(.failure(error))
                return
            }

            onFinish(.success(result))
        }
    }
}

#Preview {
    SettingsView()
}
