////
////  SaveTeamsCacheTests.swift
////  LigasEcAppTests
////
////  Created by José Briones on 10/3/25.
////
//
//import XCTest
//@testable import LigasEcApp
//
//final class SaveTeamsCacheTests: XCTestCase {
//    
//    func test_init_doesNotMessageStoreUponCreation() {
//        // Arrange
//        let (_, store) = makeSUT()
//        
//        // Assert
//        XCTAssertEqual(store.receivedMessages, [])
//    }
//    
//    func test_save_requestsToSaveCache() {
//        // Arrange
//        let id = "id"
//        let (sut, store) = makeSUT()
//        
//        // Act
//        _ = try? sut.save(mockTeams().models, with: id)
//        
//        // Assert
//        XCTAssertEqual(store.receivedMessages, [.insert(mockTeams().local, id)])
//    }
//    
//    func test_save_succeedsOnSuccessfulCacheInsertion() {
//        // Arrange
//        let id = "id"
//        let (sut, store) = makeSUT()
//        
//        // Act & Assert
//        expect(sut, with: id, toCompleteWithError: nil, when: {
//            store.completeInsertionSuccessfully()
//        })
//    }
//            
//    func test_save_failsOnInsertionError() {
//        // Arrange
//        let id = "id"
//        let (sut, store) = makeSUT()
//        let insertionError = anyNSError()
//
//        // Act & Assert
//        expect(sut, with: id, toCompleteWithError: insertionError, when: {
//            store.completeInsertion(with: insertionError)
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTeamLoader, store: TeamStoreSpy) {
//        let store = TeamStoreSpy()
//        let sut = LocalTeamLoader(store: store)
//        trackForMemoryLeaks(store, file: file, line: line)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        return (sut, store)
//    }
//    
//    private func expect(_ sut: LocalTeamLoader, with id: String, toCompleteWithError expectedError: NSError?, when action: () -> Void?, file: StaticString = #filePath, line: UInt = #line) {
//        do {
//            // Act
//            try sut.save(mockTeams().models, with: id)
//        } catch {
//            // Assert
//            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
//        }
//    }
//}
//
