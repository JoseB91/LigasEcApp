//
//  ManagedLeague.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import CoreData

@objc(ManagedLeague)
class ManagedLeague: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var data: Data?
    @NSManaged var logoURL: URL
    @NSManaged var cache: ManagedCache
    @NSManaged var teams: NSOrderedSet
}

extension ManagedLeague {
    static func getImageData(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let cachedData = URLImageCache.shared.getImageData(for: url) {
            return cachedData
        }

        if let league = try getFirst(with: url, in: context), let imageData = league.data {
            URLImageCache.shared.setImageData(imageData, for: url)
            return imageData
        }
        
        return nil
    }
    
    static func getFirst(with url: URL, in context: NSManagedObjectContext) throws -> ManagedLeague? {
        let request = NSFetchRequest<ManagedLeague>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedLeague.logoURL), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func fetchLeagues(from localLeagues: [LocalLeague], in context: NSManagedObjectContext) -> NSOrderedSet {
        let leagues = NSOrderedSet(array: localLeagues.map { local in
            let managed = ManagedLeague(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.logoURL = local.logoURL
            if let cachedData = URLImageCache.shared.getImageData(for: local.logoURL) {
                managed.data = cachedData
            }
            return managed
        })
        return leagues
    }
    
    static func find(with id: String, in context: NSManagedObjectContext) throws -> ManagedLeague? {
        let request = NSFetchRequest<ManagedLeague>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    var local: LocalLeague {
        return LocalLeague(id: id, name: name, logoURL: logoURL)
    }
    
    var localTeams: [LocalTeam] {
        return teams.compactMap { ($0 as? ManagedTeam)?.local }
    }
}
