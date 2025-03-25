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
        case insert([LocalTeam], String)
        case retrieve(String)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<[LocalTeam]?, Error>?

    // MARK: Insert
    public func insert(_ teams: [LocalTeam], with id: String) throws {
        receivedMessages.append(.insert(teams, id))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    public func retrieve(with id: String) throws -> [LocalTeam]? {
        receivedMessages.append(.retrieve(id))
        return try retrievalResult?.get()
    }
        
    func completeRetrievalWithEmptyCache(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with teams: [LocalTeam]) {
        retrievalResult = .success(teams)
    }
}
