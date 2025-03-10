//
//  InMemoryStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation

public class InMemoryStore {
    private var coachesCache: CachedTeams?
    private var coachImageDataCache = NSCache<NSURL, NSData>()

    public init() {}
}

extension InMemoryStore: TeamStore {
    public func delete() throws {
        coachesCache = nil
    }

    public func insert(_ teams: [LocalTeam], timestamp: Date) throws {
        coachesCache = CachedTeams(teams: teams, timestamp: timestamp)
    }

    public func retrieve() throws -> CachedTeams? {
        coachesCache
    }
}

//extension InMemoryStore: CoachImageStoreProtocol {
//    public func insert(_ data: Data, for url: URL) throws {
//        coachImageDataCache.setObject(data as NSData, forKey: url as NSURL)
//    }
//
//    public func retrieve(dataForURL url: URL) throws -> Data? {
//        coachImageDataCache.object(forKey: url as NSURL) as Data?
//    }
//}
