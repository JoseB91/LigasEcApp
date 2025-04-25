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
    
    func test_save_requestsToSaveCache() async {
        // Arrange
        let id = "id"
        let (sut, store) = makeSUT()
        
        // Act
        _ = try? await sut.save(mockTeams().models, with: id)
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.insert(mockTeams().local, id)])
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() async {
        // Arrange
        let id = "id"
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, with: id, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
            
    func test_save_failsOnInsertionError() async {
        // Arrange
        let id = "id"
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()

        // Act & Assert
        await expect(sut, with: id, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTeamLoader, store: TeamStoreSpy) {
        let store = TeamStoreSpy()
        let sut = LocalTeamLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalTeamLoader, with id: String, toCompleteWithError expectedError: NSError?, when action: () async -> Void?, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            // Act
            await action()
            
            try await sut.save(mockTeams().models, with: id)
        } catch {
            // Assert
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}

