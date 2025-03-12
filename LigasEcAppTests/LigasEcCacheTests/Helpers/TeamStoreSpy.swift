//
//  TeamStoreSpy.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

import Foundation
import LigasEcApp

public class TeamStoreSpy: TeamStore {
    enum ReceivedMessage: Equatable {
        case delete
        case insert([LocalTeam], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedTeams?, Error>?

    // MARK: Delete
    public func delete() throws {
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
    public func insert(_ teams: [LocalTeam], timestamp: Date) throws {
        receivedMessages.append(.insert(teams, timestamp))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    public func retrieve() throws -> CachedTeams? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with teams: [LocalTeam], timestamp: Date) {
        retrievalResult = .success(CachedTeams(teams: teams, timestamp: timestamp))
    }
}
