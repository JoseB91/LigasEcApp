//
//  TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation
    
public protocol TeamStore {
    func insert(_ teams: [LocalTeam], with id: String) async throws
    func retrieve(with id: String) async throws -> [LocalTeam]?
}


