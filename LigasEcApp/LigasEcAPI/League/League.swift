//
//  League.swift
//  LigasEcAPI
//
//  Created by José Briones on 23/2/25.
//

import Foundation

public struct League: Hashable, Identifiable {
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
