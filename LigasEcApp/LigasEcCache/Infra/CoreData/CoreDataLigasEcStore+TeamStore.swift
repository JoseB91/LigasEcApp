//
//  CoreDataLigasEcStore+TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

extension CoreDataLigasEcStore: TeamStore {
    
    public func retrieve(with id: String) async throws -> CachedTeams? {
        try await context.perform { [context] in
            try ManagedLeague.find(with: id, in: context).map { league in
                CachedTeams(teams: league.localTeams, timestamp: league.timestamp ?? .distantPast)
            }
        }
    }
    
    public func insert(_ teams: [LocalTeam], with id: String, timestamp: Date) async throws {
        try await context.perform { [context] in
            let managedLeague = try ManagedLeague.find(with: id, in: context)
            managedLeague?.timestamp = timestamp
            managedLeague?.teams = ManagedTeam.fetchTeams(from: teams, timestamp: timestamp, in: context)
            try context.save()
        }
    }
}
