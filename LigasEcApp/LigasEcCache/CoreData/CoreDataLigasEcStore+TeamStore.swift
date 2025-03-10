//
//  CoreDataLigasEcStore+TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

extension CoreDataLigasEcStore: TeamStore {
    
    public func retrieve() throws -> CachedTeams? {
        try ManagedCache.find(in: context).map {
            CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
        }
    }
    
    public func insert(_ teams: [LocalTeam], timestamp: Date) throws {
        let managedCache = try ManagedCache.newUniqueInstance(in: context)
        managedCache.timestamp = timestamp
        managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
        try context.save()
    }
    
    public func delete() throws {
        try ManagedCache.deleteCache(in: context)
    }
}
