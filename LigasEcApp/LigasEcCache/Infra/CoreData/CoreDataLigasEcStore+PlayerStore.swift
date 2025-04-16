//
//  CoreDataLigasEcStore+PlayerStore.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import CoreData

extension CoreDataLigasEcStore: PlayerStore {
    //TODO: Tests
    
    public func retrieve(with id: String) async throws -> [LocalPlayer]? {
        try await context.perform { [context] in
            try ManagedTeam.find(with: id, in: context).map { $0.localPlayers }
        }
    }
    
    public func insert(_ players: [LocalPlayer], with id: String) async throws {
        try await context.perform { [context] in
            let managedTeam = try ManagedTeam.find(with: id, in: context)
            managedTeam?.players = ManagedPlayer.fetchPlayers(from: players, in: context)
            try context.save()
        }
    }
}
