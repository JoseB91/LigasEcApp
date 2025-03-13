//
//  TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation
import LigasEcAPI

public typealias CachedTeams = (teams: [LocalTeam], timestamp: Date)
    
public protocol TeamStore {
    func deleteTeams(with id: String) throws
    func insert(_ teams: [LocalTeam], with id: String, timestamp: Date) throws
    func retrieve(with id: String) throws -> CachedTeams?
}


