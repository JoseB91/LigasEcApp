//
//  PlayerStore.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import Foundation
    
public typealias CachedPlayers = (players: [LocalPlayer], timestamp: Date)

public protocol PlayerStore {
    func insert(_ players: [LocalPlayer], with id: String, timestamp: Date) async throws
    func retrieve(with id: String) async throws -> CachedPlayers?
}
