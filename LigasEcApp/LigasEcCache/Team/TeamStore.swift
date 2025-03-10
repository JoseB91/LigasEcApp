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
    func delete() throws
    func insert(_ teams: [LocalTeam], timestamp: Date) throws
    func retrieve() throws -> CachedTeams?
}

