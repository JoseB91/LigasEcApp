//
//  LocalImageLoader.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation

public final class LocalImageLoader {
    private let store: ImageStore
    
    public init(store: ImageStore) {
        self.store = store
    }
}

public protocol ImageCache {
    func save(_ data: Data, for url: URL, on table: Table) async throws
}


extension LocalImageLoader: ImageCache {
    public enum SaveError: Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL, on table: Table) async throws {
        do {
            try await store.insert(data, for: url, on: table)
        } catch {
            throw SaveError.failed
        }
    }
}

public protocol ImageLoader {
    func loadImageData(from url: URL, on table: Table) async throws -> Data
}

extension LocalImageLoader: ImageLoader {
    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    public func loadImageData(from url: URL, on table: Table) async throws -> Data {
            do {
                if let imageData = try await store.retrieve(dataFor: url, on: table) {
                    return imageData
                }
            } catch {
                throw LoadError.failed
            }
        throw LoadError.notFound
    }
}


