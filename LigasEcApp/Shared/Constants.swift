//
//  Constants.swift
//  LigasEcApp
//
//  Created by José Briones on 15/9/25.
//

import SwiftUI

struct Constants {
    
    static var ligasEc: LocalizedStringKey { "LIGAS_EC" }
    static var settings: LocalizedStringKey { "SETTINGS" }
    static var privacyPolicy: LocalizedStringKey { "PRIVACY_POLICY" }
    static var sendEmail: LocalizedStringKey { "SEND_EMAIL" }
    static var contactSubject: LocalizedStringKey { "CONTACT_SUBJECT" }
    static var contactBody: LocalizedStringKey { "CONTACT_BODY" }
    static var pdfViewer: LocalizedStringKey { "PDF_VIEWER" }
    static var pdfNotFound: LocalizedStringKey { "PDF_NOT_FOUND" }
    static var appVersion: LocalizedStringKey { "APP_VERSION" }

    // Accessibility
    static var loadingLeagues: LocalizedStringKey { "LOADING_LEAGUES" }
    static var loadingTeams: LocalizedStringKey { "LOADING_TEAMS" }
    static var loadingPlayers: LocalizedStringKey { "LOADING_PLAYERS" }
    static var loadingImage: LocalizedStringKey { "LOADING_IMAGE" }
    static var selectLeague: LocalizedStringKey { "SELECT_LEAGUE" }
    static var selectTeam: LocalizedStringKey { "SELECT_TEAM" }
    static var playerNumber: LocalizedStringKey { "PLAYER_NUMBER" }
    static var noPhotoAvailable: LocalizedStringKey { "NO_PHOTO_AVAILABLE" }
    static var currentVersion: LocalizedStringKey { "CURRENT_VERSION" }
    static var opensPrivacyPolicy: LocalizedStringKey { "OPENS_PRIVACY_POLICY" }
    static var opensEmailClient: LocalizedStringKey { "OPENS_EMAIL_CLIENT" }
    static var ligasEcLogo: LocalizedStringKey { "LIGAS_EC_LOGO" }

    //Error
    static let ok = "OK"
    static let error = "Error"
    
    //Players
    static var coach: LocalizedStringKey { "COACH" }
    static var goalkeeper: LocalizedStringKey { "GOALKEEPER" }
    static var defender: LocalizedStringKey { "DEFENDER" }
    static var midfielder: LocalizedStringKey { "MIDFIELDER" }
    static var forward: LocalizedStringKey { "FORWARD" }
    
    static let portero = "Portero"
    static let defensa = "Defensa"
    static let centrocampista = "Centrocampista"
    static let delantero = "Delantero"
    static let entrenador = "Entrenador"
}
