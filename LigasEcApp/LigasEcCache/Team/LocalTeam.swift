//
//  LocalTeam.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation

public struct LocalTeam: Equatable {
    public let id: String
    public let name: String
    public let logoURL: URL
    
    public init(id: String, name: String, logoURL: URL) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
    }
}
