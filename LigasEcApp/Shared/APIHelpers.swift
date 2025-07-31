//
//  APIHelpers.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

enum MapperError: Error {
    case unsuccessfullyResponse
}
