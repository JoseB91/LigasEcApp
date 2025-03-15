//
//  PlayerStore.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import Foundation
    
public protocol PlayerStore {
    func deletePlayers(with id: String) throws
    func insert(_ players: [LocalPlayer], with id: String) throws
    func retrieve(with id: String) throws -> [LocalPlayer]?
}

