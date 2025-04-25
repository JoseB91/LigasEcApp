//
//  SaveLeaguesCacheTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 24/3/25.
//

import XCTest
@testable import LigasEcApp

final class SaveLeaguesCacheTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_deletesCacheOnInsertionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
            store.completeDeletionSuccessfully()
        })
    }
    
    func test_save_failsOnInsertionErrorAndDeletionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: anyNSError(), when: {
            store.completeInsertion(with: anyNSError())
            store.completeDeletion(with: anyNSError())
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalLeagueLoader, store: LeagueStoreSpy) {
        let store = LeagueStoreSpy()
        let sut = LocalLeagueLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalLeagueLoader, toCompleteWithError expectedError: NSError?, when action: () async -> Void?, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            // Act
            try await sut.save(mockLeagues().models)
            
            await action()            
        } catch {
            // Assert
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}

