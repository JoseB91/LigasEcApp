//
//  CoreDataLigasEcStore+ImageStore.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation

extension CoreDataLigasEcStore: ImageStore { //TODO: Tests
    
    public func insert(_ data: Data, for url: URL) throws {
        try ManagedTeam.getFirst(with: url, in: context)
            .map { $0.data = data }
            .map(context.save)
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data?  {
        try ManagedTeam.getImageData(with: url, in: context)
    }
    
}
