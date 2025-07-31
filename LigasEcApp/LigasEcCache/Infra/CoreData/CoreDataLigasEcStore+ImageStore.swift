//
//  CoreDataLigasEcStore+ImageStore.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import CoreData

extension CoreDataLigasEcStore: ImageStore {
    
    public func insert(_ data: Data, for url: URL, on table: Table) async throws {
        try await context.perform { [context] in 
            switch table {
            case .league:
                if let managedLeague = try ManagedLeague.getFirst(with: url, in: context) {
                    managedLeague.data = data
                }
            case .team:
                if let managedTeam = try ManagedTeam.getFirst(with: url, in: context) {
                    managedTeam.data = data
                }
            case .player:
                if let managedPlayer = try ManagedPlayer.getFirst(with: url, in: context) {
                    managedPlayer.data = data
                }
            }
            try context.save()
        }
    }

    public func retrieve(dataFor url: URL, on table: Table) async throws -> Data?  {
        try await context.perform { [context] in
            switch table {
            case .league:
                return try ManagedLeague.getImageData(with: url, in: context)
            case .team:
                return try ManagedTeam.getImageData(with: url, in: context)
            case .player:
                return try ManagedPlayer.getImageData(with: url, in: context)
            }
        }
    }
    
}
