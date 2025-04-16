//
//  CoreDataLigasEcStore+TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

extension CoreDataLigasEcStore: TeamStore {
    
    public func retrieve(with id: String) async throws -> [LocalTeam]? {
        try await context.perform { [context] in
            try ManagedLeague.find(with: id, in: context).map { $0.localTeams }
        }
    }
    
    public func insert(_ teams: [LocalTeam], with id: String) async throws {
        try await context.perform { [context] in
            let managedLeague = try ManagedLeague.find(with: id, in: context)
            managedLeague?.teams = ManagedTeam.fetchTeams(from: teams, in: context)
            try context.save()
        }
    }
}
