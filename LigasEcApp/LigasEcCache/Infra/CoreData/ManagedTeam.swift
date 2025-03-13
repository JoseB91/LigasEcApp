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
    @NSManaged var logoURL: URL?
    @NSManaged var league: ManagedLeague
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
            if let url = local.logoURL, let imageData = context.userInfo[url] as? Data {
                managed.data = imageData
            } else {
                managed.data = nil
            }
            return managed
        })
        context.userInfo.removeAllObjects()
        return teams
    }

    var local: LocalTeam {
        return LocalTeam(id: id, name: name, logoURL: logoURL)
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()

        managedObjectContext?.userInfo[logoURL ?? ""] = data
    }
}
