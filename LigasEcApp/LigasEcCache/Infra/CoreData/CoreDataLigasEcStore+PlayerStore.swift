//
//  CoreDataLigasEcStore+PlayerStore.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import CoreData

extension CoreDataLigasEcStore: PlayerStore {
    
    public func retrieve(with id: String) async throws -> CachedPlayers? {
        try await context.perform { [context] in
            try ManagedTeam.find(with: id, in: context).map { team in
                CachedPlayers(players: team.localPlayers, timestamp: team.timestamp ?? .distantPast)
            }
        }
    }
    
    public func insert(_ players: [LocalPlayer], with id: String, timestamp: Date) async throws {
        try await context.perform { [context] in
            let managedTeam = try ManagedTeam.find(with: id, in: context)
            managedTeam?.timestamp = timestamp
            managedTeam?.players = ManagedPlayer.fetchPlayers(from: players, timestamp: timestamp, in: context)
            try context.save()
        }
    }
}
