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
    @NSManaged var stageId: String
    @NSManaged var name: String
    @NSManaged var data: Data?
    @NSManaged var logoURL: URL
    @NSManaged var cache: ManagedCache
    @NSManaged var teams: NSOrderedSet
}

extension ManagedLeague {
    static func getImageData(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try getFirst(with: url, in: context)?.data
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
            managed.stageId = local.stageId
            managed.name = local.name
            managed.logoURL = local.logoURL
            managed.data = context.userInfo[local.logoURL] as? Data
            return managed
        })
        context.userInfo.removeAllObjects()
        return leagues
    }
    
    static func find(with id: String, in context: NSManagedObjectContext) throws -> ManagedLeague? {
        let request = NSFetchRequest<ManagedLeague>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func deleteCache(with id: String, in context: NSManagedObjectContext) throws {
        try find(with: id, in: context).map(context.delete).map(context.save)
    }

    var local: LocalLeague {
        return LocalLeague(id: id, stageId: stageId, name: name, logoURL: logoURL)
    }
    
    var localTeams: [LocalTeam] {
        return teams.compactMap { ($0 as? ManagedTeam)?.local }
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()

        managedObjectContext?.userInfo[logoURL] = data
    }
}
