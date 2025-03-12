//
//  CoreDataLigasEcStore+TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

//extension CoreDataLigasEcStore: TeamStore { //TODO: Tests
//    
//    public func retrieve() throws -> CachedTeams? {
//        try ManagedCache.find(in: context).map {
//            CachedTeams(teams: $0.localTeams, timestamp: $0.timestamp)
//        }
//    }
//    
//    public func insert(_ teams: [LocalTeam], timestamp: Date) throws {
//        let managedCache = try ManagedCache.newUniqueInstance(in: context)
//        managedCache.timestamp = timestamp
//        managedCache.teams = ManagedTeam.fetchTeams(from: teams, in: context)
//        try context.save()
//    }
//    
//    public func delete() throws {
//        try ManagedCache.deleteCache(in: context)
//    }
//}
