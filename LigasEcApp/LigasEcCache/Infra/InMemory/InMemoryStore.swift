//
//  InMemoryStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation

public class InMemoryStore {
    private var teamsCache: CachedTeams?
    private var teamImageDataCache = NSCache<NSURL, NSData>()

    public init() {}
}

extension InMemoryStore: TeamStore {
    public func delete() throws {
        teamsCache = nil
    }

    public func insert(_ teams: [LocalTeam], timestamp: Date) throws {
        teamsCache = CachedTeams(teams: teams, timestamp: timestamp)
    }

    public func retrieve() throws -> CachedTeams? {
        teamsCache
    }
}

extension InMemoryStore: ImageStore {
    public func insert(_ data: Data, for url: URL) throws {
        teamImageDataCache.setObject(data as NSData, forKey: url as NSURL)
    }

    public func retrieve(dataForURL url: URL) throws -> Data? {
        teamImageDataCache.object(forKey: url as NSURL) as Data?
    }
}
