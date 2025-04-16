//
//  PlayerStore.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import Foundation
    
public protocol PlayerStore {
    func insert(_ players: [LocalPlayer], with id: String) async throws
    func retrieve(with id: String) async throws -> [LocalPlayer]?
}

