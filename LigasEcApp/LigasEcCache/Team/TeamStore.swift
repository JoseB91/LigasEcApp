//
//  TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation
    
public typealias CachedTeams = (teams: [LocalTeam], timestamp: Date)

public protocol TeamStore {
    func insert(_ teams: [LocalTeam], with id: String, timestamp: Date) async throws
    func retrieve(with id: String) async throws -> CachedTeams?
}

