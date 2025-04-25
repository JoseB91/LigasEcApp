//
//  LeagueStoreSpy.swift
//  LigasEcAppTests
//
//  Created by José Briones on 24/3/25.
//

import Foundation
import LigasEcApp

public class LeagueStoreSpy: LeagueStore {
    enum ReceivedMessage: Equatable {
        case delete
        case insert([LocalLeague], Date)
        case retrieve
    }

    private(set) var receivedMessages = [ReceivedMessage]()

    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedLeagues?, Error>?

    // MARK: Delete
    public func deleteCache() async throws {
        receivedMessages.append(.delete)
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }

    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }

    // MARK: Insert
    public func insert(_ leagues: [LocalLeague], timestamp: Date) async throws {
        receivedMessages.append(.insert(leagues, timestamp))
        try insertionResult?.get()
//        let completion = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//            insertionCompletions.append { error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else {
//                    continuation.resume()
//                }
//            }
//        }
//        return completion
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }

    // MARK: Retrieve
    public func retrieve() async throws -> CachedLeagues? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }

    func completeRetrieval(with leagues: [LocalLeague], timestamp: Date) {
        retrievalResult = .success(CachedLeagues(leagues: leagues, timestamp: timestamp))
    }
}
