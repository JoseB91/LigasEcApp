//
//  ManagedCache.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var leagues: NSOrderedSet
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try deleteCache(in: context)
        return ManagedCache(context: context)
    }
    
    static func cacheExists(in context: NSManagedObjectContext) throws -> Bool {
        try find(in: context) != nil
    }
    
    var localLeagues: [LocalLeague] {
        return leagues.compactMap { ($0 as? ManagedLeague)?.local }
    }
}
