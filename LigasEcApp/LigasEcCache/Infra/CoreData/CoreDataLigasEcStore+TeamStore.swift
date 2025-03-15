//
//  CoreDataLigasEcStore+TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

extension CoreDataLigasEcStore: TeamStore {
    //TODO: Tests
    
    public func retrieve(with id: String) throws -> [LocalTeam]? {
        try ManagedLeague.find(with: id, in: context).map { $0.localTeams }
    }
    
    public func insert(_ teams: [LocalTeam], with id: String) throws {
        let managedLeague = try ManagedLeague.find(with: id, in: context)
        managedLeague?.teams = ManagedTeam.fetchTeams(from: teams, in: context)
        try context.save()
    }
    
    public func deleteTeams(with id: String) throws {
        try ManagedLeague.deleteCache(with: id, in: context)
    }
}
