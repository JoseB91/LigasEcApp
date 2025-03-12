//
//  ImageStore.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation

public protocol ImageStore {
    func insert(_ data: Data, for url: URL, on table: Table) throws
    func retrieve(dataFor url: URL, on table: Table) throws -> Data?
}
