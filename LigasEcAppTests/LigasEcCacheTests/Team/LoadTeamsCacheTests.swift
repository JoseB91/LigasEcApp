//
//  LoadTeamsCacheTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

import XCTest
import LigasEcAPI
@testable import LigasEcApp

final class LoadTeamsCacheTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        // Arrange
        let id = "id"
        let (sut, store) = makeSUT()
        
        // Act
        _ = try? sut.load(with: id, dataSource: .FlashLive)
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.retrieve(id)])
    }
    
    func test_load_deliversCachedTeams() {
        // Arrange
        let id = "id"
        let teams = mockTeams()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        expect(sut, with: id, toCompleteWith: .success(teams.models), when: {
            store.completeRetrieval(with: teams.local)
        })
    }
    
    func test_load_failsOnEmptyCache() {
        // Arrange
        let id = "id"
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()

        // Act & Assert
        expect(sut, with: id, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrievalWithEmptyCache(with: retrievalError)
        })
    }
    
    func test_load_failsOnRetrievalError() {
        // Arrange
        let id = "id"
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        expect(sut, with: id, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let id = "id"
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: anyNSError())
        
        _ = try? sut.load(with: id, dataSource: .FlashLive)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(id)])
    }
    
    func test_load_hasNoSideEffectsOnSuccessfullRetrieval() {
        let id = "id"
        let localTeams = mockTeams().local
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: localTeams)
        
        _ = try? sut.load(with: id, dataSource: .FlashLive)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(id)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTeamLoader, store: TeamStoreSpy) {
        let store = TeamStoreSpy()
        let sut = LocalTeamLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalTeamLoader, with id: String, toCompleteWith expectedResult: Result<[Team], Error>, when action: () -> Void?, file: StaticString = #filePath, line: UInt = #line) {
        action()
        
        let receivedResult = Result { try sut.load(with: id, dataSource: .FlashLive) }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedImages), .success(expectedImages)):
            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
