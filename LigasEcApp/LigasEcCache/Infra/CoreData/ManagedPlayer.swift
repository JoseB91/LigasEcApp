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
    @NSManaged var number: NSNumber?
    @NSManaged var position: String
    @NSManaged var flagId: NSNumber?
    @NSManaged var nationality: String?
    @NSManaged var data: Data?
    @NSManaged var photoURL: URL?
    @NSManaged var team: ManagedTeam
    
    var flagIdRaw: Int? {
        get {
            return flagId?.intValue
        }
        set {
            if let newValue = newValue {
                flagId = NSNumber(value: newValue)
            } else {
                flagId = nil
            }
        }
    }
    
    var numberRaw: Int? {
        get {
            return number?.intValue
        }
        set {
            if let newValue = newValue {
                number = NSNumber(value: newValue)
            } else {
                number = nil
            }
        }
    }
}

extension ManagedPlayer {
    static func getImageData(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let cachedData = URLImageCache.shared.getImageData(for: url) {
            return cachedData
        }
        
        if let player = try getFirst(with: url, in: context), let imageData = player.data {
            URLImageCache.shared.setImageData(imageData, for: url)
            return imageData
        }
        
        return nil
    }
    
    static func getFirst(with url: URL, in context: NSManagedObjectContext) throws -> ManagedPlayer? {
        let request = NSFetchRequest<ManagedPlayer>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedPlayer.photoURL), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func fetchPlayers(from localPlayers: [LocalPlayer], in context: NSManagedObjectContext) -> NSOrderedSet {
        let players = NSOrderedSet(array: localPlayers.map { local in
            let managed = ManagedPlayer(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.numberRaw = local.number
            managed.position = local.position
            managed.flagIdRaw = local.flagId
            managed.nationality = local.nationality
            managed.photoURL = local.photoURL
            if let photoURL = local.photoURL,
                let cachedData = URLImageCache.shared.getImageData(for: photoURL) {
                managed.data = cachedData
            }
            return managed
        })
        return players
    }
    
    var local: LocalPlayer {
        return LocalPlayer(id: id,
                           name: name,
                           number: numberRaw,
                           position: position,
                           flagId: flagIdRaw,
                           nationality: nationality,
                           photoURL: photoURL)
    }
}
