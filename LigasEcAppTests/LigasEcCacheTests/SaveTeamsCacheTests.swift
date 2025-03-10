//
//  SaveTeamsCacheTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

import XCTest
@testable import LigasEcApp

final class SaveTeamsCacheTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [])
    }
        
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        // Arrange
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        store.completeDeletion(with: deletionError)
 
        // Act
        try? sut.save(mockTeams().models)
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.delete])
    }
    
    func test_save_requestNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        // Arrange
        let timestamp = Date()
        let teams = mockTeams()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        store.completeDeletionSuccessfully()
        
        // Act
        try? sut.save(teams.models)

        // Assert
        XCTAssertEqual(store.receivedMessages, [.delete, .insert(teams.local, timestamp)])
    }
    
    func test_save_failsOnDeletionError() {
        // Arrange
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        // Act & Assert
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        // Arrange
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()

        // Act & Assert
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeDeletion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTeamLoader, store: TeamsStoreSpy) {
        let store = TeamsStoreSpy()
        let sut = LocalTeamLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalTeamLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void?, file: StaticString = #filePath, line: UInt = #line) {
        do {
            // Act
            try sut.save(mockTeams().models)
        } catch {
            // Assert
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}

class TeamsStoreSpy: TeamStore {
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
    func delete() throws {
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
    func insert(_ teams: [LocalTeam], timestamp: Date) throws {
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
    func retrieve() throws -> CachedTeams? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }

    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with teams: [LocalTeam], timestamp: Date) {
        retrievalResult = .success(CachedTeams(teams: teams, timestamp: timestamp))
    }
}


