//
//  LoadPlayersCacheTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 25/4/25.
//

import XCTest
@testable import LigasEcApp

final class LoadPlayersCacheTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() async {
        // Arrange
        let id = "id"
        let (sut, store) = makeSUT()
        
        // Act
        _ = try? await sut.load(with: id, dataSource: .FlashLive)
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.retrieve(id)])
    }
    
    func test_load_deliversCachedPlayers() async {
        // Arrange
        let id = "id"
        let players = mockPlayers()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, with: id, toCompleteWith: .success(players.models), when: {
            store.completeRetrieval(with: players.local)
        })
    }
    
    func test_load_failsOnEmptyCache() async {
        // Arrange
        let id = "id"
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, with: id, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrievalWithEmptyCache(with: retrievalError)
        })
    }
    
    func test_load_failsOnRetrievalError() async {
        // Arrange
        let id = "id"
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, with: id, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() async {
        let id = "id"
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: anyNSError())
        
        _ = try? await sut.load(with: id, dataSource: .FlashLive)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(id)])
    }
    
    func test_load_hasNoSideEffectsOnSuccessfullRetrieval() async {
        let id = "id"
        let localPlayers = mockPlayers().local
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: localPlayers)
        
        _ = try? await sut.load(with: id, dataSource: .FlashLive)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(id)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalPlayerLoader, store: PlayerStoreSpy) {
        let store = PlayerStoreSpy()
        let sut = LocalPlayerLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalPlayerLoader, with id: String, toCompleteWith expectedResult: Result<[Player], Error>, when action: () async -> Void?, file: StaticString = #filePath, line: UInt = #line) async {
        await action()
        
        let receivedResult: Result<[Player], Error>
        
        do {
            let receivedPlayers = try await sut.load(with: id, dataSource: .FlashLive)
            receivedResult = .success(receivedPlayers)
        } catch {
            receivedResult = .failure(error)
        }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedPlayers), .success(expectedPlayers)):
            XCTAssertEqual(receivedPlayers, expectedPlayers, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
