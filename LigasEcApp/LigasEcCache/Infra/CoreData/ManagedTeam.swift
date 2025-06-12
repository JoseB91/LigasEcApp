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
        if let cachedData = URLImageCache.shared.getImageData(for: url) {
            return cachedData
        }

        if let team = try getFirst(with: url, in: context), let imageData = team.data {
            URLImageCache.shared.setImageData(imageData, for: url)
            return imageData
        }
        
        return nil
    }
    
    static func getFirst(with url: URL, in context: NSManagedObjectContext) throws -> ManagedTeam? {
        let request = NSFetchRequest<ManagedTeam>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedTeam.logoURL), url])
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func fetchTeams(from localTeams: [LocalTeam], in context: NSManagedObjectContext) -> NSOrderedSet {
        let teams = NSOrderedSet(array: localTeams.map { local in
            let managed = ManagedTeam(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.logoURL = local.logoURL
            if let cachedData = URLImageCache.shared.getImageData(for: local.logoURL) {
                managed.data = cachedData
            }
            return managed
        })
        return teams
    }
    
    static func find(with id: String, in context: NSManagedObjectContext) throws -> ManagedTeam? {
        let request = NSFetchRequest<ManagedTeam>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    var local: LocalTeam {
        return LocalTeam(id: id, name: name, logoURL: logoURL)
    }
    
    var localPlayers: [LocalPlayer] {
        return players.compactMap { ($0 as? ManagedPlayer)?.local }
    }
}
