//
//  Team.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

public struct Team: Hashable, Identifiable {
    public let id: String
    public let name: String
    public let logoURL: URL
    public let dataSource: DataSource
    
    public init(id: String, name: String, logoURL: URL, dataSource: DataSource) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
        self.dataSource = dataSource
    }
}
