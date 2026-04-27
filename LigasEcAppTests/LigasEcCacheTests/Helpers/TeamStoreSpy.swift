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
        case insert([LocalTeam], String, Date)
        case retrieve(String)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedTeams?, Error>?

    // MARK: Insert
    public func insert(_ teams: [LocalTeam], with id: String, timestamp: Date) async throws {
        receivedMessages.append(.insert(teams, id, timestamp))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    public func retrieve(with id: String) async throws -> CachedTeams? {
        receivedMessages.append(.retrieve(id))
        return try retrievalResult?.get()
    }
        
    func completeRetrievalWithEmptyCache(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with teams: [LocalTeam], timestamp: Date = Date()) {
        retrievalResult = .success(CachedTeams(teams: teams, timestamp: timestamp))
    }
}
