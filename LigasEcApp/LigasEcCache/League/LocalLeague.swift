//
//  LocalLeague.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation
import LigasEcAPI

public struct LocalLeague: Equatable {
    public let id: String
    public let stageId: String
    public let name: String
    public let logoURL: URL
    
    public init(id: String, stageId: String, name: String, logoURL: URL) {
        self.id = id
        self.stageId = stageId
        self.name = name
        self.logoURL = logoURL
    }
}
