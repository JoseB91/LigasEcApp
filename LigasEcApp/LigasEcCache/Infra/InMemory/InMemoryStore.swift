//
//  InMemoryStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation

public class InMemoryStore {
    private var leaguesCache: CachedLeagues?
    private var teamsCache: [LocalTeam]?
    private var playersCache: [LocalPlayer]?
    private var leagueImageCacheData = NSCache<NSURL, NSData>()

    public init() {}
}

extension InMemoryStore: LeagueStore {
    public func deleteLeagues() throws {
        leaguesCache = nil
    }

    public func insert(_ leagues: [LocalLeague], timestamp: Date) throws {
        leaguesCache = CachedLeagues(leagues: leagues, timestamp: timestamp)
    }

    public func retrieve() throws -> CachedLeagues? {
        leaguesCache
    }
}

extension InMemoryStore: TeamStore {
    public func deleteTeams(with id: String) throws {
        teamsCache = nil
    }
    
    public func insert(_ teams: [LocalTeam], with id: String) throws {
        teamsCache = teams
    }
    
    public func retrieve(with id: String) throws -> [LocalTeam]? {
        teamsCache
    }
}

extension InMemoryStore: PlayerStore {
    public func deletePlayers(with id: String) throws {
        playersCache = nil
    }
    
    public func insert(_ players: [LocalPlayer], with id: String) throws {
        playersCache = players
    }
    
    public func retrieve(with id: String) throws -> [LocalPlayer]? {
        playersCache
    }
}

extension InMemoryStore: ImageStore {
    public func insert(_ data: Data, for url: URL, on table: Table) throws {
        leagueImageCacheData.setObject(data as NSData, forKey: url as NSURL)
    }

    public func retrieve(dataFor url: URL, on table: Table) throws -> Data? {
        leagueImageCacheData.object(forKey: url as NSURL) as Data?
    }
}
