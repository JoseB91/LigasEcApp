//
//  ManagedPlayer.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import CoreData

@objc(ManagedPlayer)
class ManagedPlayer: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var position: String
    @NSManaged var data: Data?
    @NSManaged var photoURL: URL?
    @NSManaged var team: ManagedTeam
}

extension ManagedPlayer {
    static func getImageData(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try getFirst(with: url, in: context)?.data
    }
    
    static func getFirst(with url: URL, in context: NSManagedObjectContext) throws -> ManagedPlayer? {
        let request = NSFetchRequest<ManagedPlayer>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedPlayer.photoURL), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func fetchPlayers(from localPlayers: [LocalPlayer], in context: NSManagedObjectContext) -> NSOrderedSet {
        let teams = NSOrderedSet(array: localPlayers.map { local in
            let managed = ManagedPlayer(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.position = local.position
            managed.photoURL = local.photoURL
            if let url = local.photoURL {
                managed.data = context.userInfo[url] as? Data
            }
            return managed
        })
        context.userInfo.removeAllObjects()
        return teams
    }

    var local: LocalPlayer {
        return LocalPlayer(id: id, name: name, position: position, photoURL: photoURL)
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()

        managedObjectContext?.userInfo[photoURL ?? ""] = data
    }
}
