//
//  ErrorModel.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

enum MapperError: Error {
    case unsuccessfullyResponse
}
