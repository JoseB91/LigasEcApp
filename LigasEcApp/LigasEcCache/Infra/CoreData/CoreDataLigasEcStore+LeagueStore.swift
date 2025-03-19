//
//  CoreDataLigasEcStore+LeagueStore.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import CoreData

extension CoreDataLigasEcStore: LeagueStore { //TODO: Tests
    
    public func retrieve() throws -> CachedLeagues? {
        try ManagedCache.find(in: context).map {
            CachedLeagues(leagues: $0.localLeagues, timestamp: $0.timestamp)
        }
    }
    
    public func insert(_ leagues: [LocalLeague], timestamp: Date) throws {
        if try !ManagedCache.cacheExists(in: context) {
            let managedCache = try ManagedCache.newUniqueInstance(in: context)
            managedCache.timestamp = timestamp
            managedCache.leagues = ManagedLeague.fetchLeagues(from: leagues, in: context)
            try context.save()
        }
    }
    
    public func deleteCache() throws {
        try ManagedCache.deleteCache(in: context)
    }
}
