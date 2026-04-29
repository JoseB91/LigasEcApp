//
//  LocalLeague.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation

public struct LocalLeague: Equatable, Sendable {
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
