//
//  CoreDataLigasEcStore+ImageStore.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation

extension CoreDataLigasEcStore: ImageStore { //TODO: Tests
    
    public func insert(_ data: Data, for url: URL, on table: Table) throws {
        if table == .League {
            try ManagedLeague.getFirst(with: url, in: context)
                .map { $0.data = data }
                .map(context.save)
        } else if table == .Team {
            try ManagedTeam.getFirst(with: url, in: context)
                .map { $0.data = data }
                .map(context.save)
        }  else {
            if let _ = try ManagedPlayer.getFirst(with: url, in: context) {
                try ManagedPlayer.getFirst(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            }
        }
    }
    
    public func retrieve(dataFor url: URL, on table: Table) throws -> Data?  {
        if table == .League {
            try ManagedLeague.getImageData(with: url, in: context)
        } else if table == .Team {
            try ManagedTeam.getImageData(with: url, in: context)
        } else {
            try ManagedPlayer.getImageData(with: url, in: context)
        }
    }
    
}
