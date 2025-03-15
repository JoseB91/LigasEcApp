//
//  CoreDataLigasEcStore+PlayerStore.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import CoreData

extension CoreDataLigasEcStore: PlayerStore {
    //TODO: Tests
    
    public func retrieve(with id: String) throws -> [LocalPlayer]? {
        try ManagedTeam.find(with: id, in: context).map { $0.localPlayers }
    }
    
    public func insert(_ players: [LocalPlayer], with id: String) throws {
        let managedTeam = try ManagedTeam.find(with: id, in: context)
        managedTeam?.players = ManagedPlayer.fetchPlayers(from: players, in: context)
        try context.save()
    }
    
    public func deletePlayers(with id: String) throws {
        try ManagedTeam.deleteCache(with: id, in: context)
    }
}
