//
//  PlayerStoreSpy.swift
//  LigasEcAppTests
//
//  Created by José Briones on 25/4/25.
//

import Foundation
import LigasEcApp

public class PlayerStoreSpy: PlayerStore {
    
    enum ReceivedMessage: Equatable {
        case insert([LocalPlayer], String)
        case retrieve(String)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<[LocalPlayer]?, Error>?

    // MARK: Insert
    public func insert(_ players: [LigasEcApp.LocalPlayer], with id: String) async throws {
        receivedMessages.append(.insert(players, id))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    public func retrieve(with id: String) async throws -> [LigasEcApp.LocalPlayer]? {
        receivedMessages.append(.retrieve(id))
        return try retrievalResult?.get()
    }
        
    func completeRetrievalWithEmptyCache(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with players: [LocalPlayer]) {
        retrievalResult = .success(players)
    }
}
