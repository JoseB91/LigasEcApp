//
//  ManagedTeam.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData

@objc(ManagedTeam)
class ManagedTeam: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var data: Data?
    @NSManaged var logoURL: URL
    @NSManaged var league: ManagedLeague
    @NSManaged var players: NSOrderedSet
}

extension ManagedTeam {
    static func getImageData(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try getFirst(with: url, in: context)?.data
    }
    
    static func getFirst(with url: URL, in context: NSManagedObjectContext) throws -> ManagedTeam? {
        let request = NSFetchRequest<ManagedTeam>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedTeam.logoURL), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func fetchTeams(from localTeams: [LocalTeam], in context: NSManagedObjectContext) -> NSOrderedSet {
        let teams = NSOrderedSet(array: localTeams.map { local in
            let managed = ManagedTeam(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.logoURL = local.logoURL
            managed.data = context.userInfo[local.logoURL] as? Data
            return managed
        })
        context.userInfo.removeAllObjects()
        return teams
    }
    
    static func find(with id: String, in context: NSManagedObjectContext) throws -> ManagedTeam? {
        let request = NSFetchRequest<ManagedTeam>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func deleteCache(with id: String, in context: NSManagedObjectContext) throws {
        try find(with: id, in: context).map(context.delete).map(context.save)
    }

    var local: LocalTeam {
        return LocalTeam(id: id, name: name, logoURL: logoURL)
    }
    
    var localPlayers: [LocalPlayer] {
        return players.compactMap { ($0 as? ManagedPlayer)?.local }
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()

        managedObjectContext?.userInfo[logoURL] = data
    }
}
