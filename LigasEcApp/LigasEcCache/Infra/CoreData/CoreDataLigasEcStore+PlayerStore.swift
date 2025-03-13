//
//  CoreDataLigasEcStore+PlayerStore.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import CoreData

extension CoreDataLigasEcStore: PlayerStore {
    //TODO: Tests
    
    public func retrieve(with id: String) throws -> CachedPlayers? {
        try ManagedTeam.find(with: id, in: context).map {
            CachedPlayers(players: $0.localPlayers, timestamp: Date())
        }
    }
    
    public func insert(_ players: [LocalPlayer], with id: String, timestamp: Date) throws {
        let managedTeam = try ManagedTeam.find(with: id, in: context)
        managedTeam?.league.cache.timestamp = timestamp
        managedTeam?.players = ManagedPlayer.fetchPlayers(from: players, in: context)
        try context.save()
    }
    
    public func deletePlayers(with id: String) throws {
        try ManagedTeam.deleteCache(with: id, in: context)
    }
}
