//
//  LeagueStore.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation

public typealias CachedLeagues = (leagues: [LocalLeague], timestamp: Date)
    
public protocol LeagueStore {
    func deleteCache() async throws
    func insert(_ leagues: [LocalLeague], timestamp: Date) async throws
    func retrieve() async throws -> CachedLeagues?
}
