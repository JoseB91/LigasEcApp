//
//  CoreDataLigasEcStore+TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

extension CoreDataLigasEcStore: TeamStore {
    //TODO: Tests
    
    public func retrieve(with id: String) throws -> CachedTeams? {
        try ManagedLeague.find(with: id, in: context).map {
            CachedTeams(teams: $0.localTeams, timestamp: $0.cache.timestamp)
        }
    }
    
    public func insert(_ teams: [LocalTeam], with id: String, timestamp: Date) throws {
        let managedLeague = try ManagedLeague.find(with: id, in: context)
        managedLeague?.cache.timestamp = timestamp
        managedLeague?.teams = ManagedTeam.fetchTeams(from: teams, in: context)
        try context.save()
    }
    
    public func deleteTeams(with id: String) throws {
        try ManagedLeague.deleteCache(with: id, in: context)
    }
}
