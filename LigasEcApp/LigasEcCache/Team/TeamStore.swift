//
//  TeamStore.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation
import LigasEcAPI
    
public protocol TeamStore {
    func deleteTeams(with id: String) throws
    func insert(_ teams: [LocalTeam], with id: String) throws
    func retrieve(with id: String) throws -> [LocalTeam]?
}


