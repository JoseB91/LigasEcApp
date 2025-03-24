////
////  ValidateCacheTests.swift
////  LigasEcAppTests
////
////  Created by José Briones on 10/3/25.
////
//
//import XCTest
//@testable import LigasEcApp
//
//class ValidateCacheTests: XCTestCase {
//    
//    func test_init_doesNotMessageStoreUponCreation() {
//        let (_, store) = makeSUT()
//        
//        XCTAssertEqual(store.receivedMessages, [])
//    }
//    
//    func test_validateCache_deletesCacheOnRetrievalError() {
//        let (sut, store) = makeSUT()
//        store.completeRetrieval(with: anyNSError())
//        
//        try? sut.validateCache()
//
//        XCTAssertEqual(store.receivedMessages, [.retrieve, .delete])
//    }
//
////    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
////        let (sut, store) = makeSUT()
////        store.completeRetrievalWithEmptyCache()
////
////        try? sut.validateCache()
////        
////        XCTAssertEqual(store.receivedMessages, [.retrieve])
////    }
//    
//    func test_validateCache_doesNotDeleteOnNonExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        store.completeRetrieval(with: teams.local, timestamp: nonExpiredTimestamp)
//        
//        try? sut.validateCache()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//    }
//    
//    func test_validateCache_deletesOnCacheExpiration() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        store.completeRetrieval(with: teams.local, timestamp: expirationTimestamp)
//
//        try? sut.validateCache()
//
//        XCTAssertEqual(store.receivedMessages, [.retrieve, .delete])
//    }
//    
//    func test_validateCache_deletesOnExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        store.completeRetrieval(with: teams.local, timestamp: expiredTimestamp)
//
//        try? sut.validateCache()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve, .delete])
//    }
//    
//    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() {
//        let (sut, store) = makeSUT()
//        let deletionError = anyNSError()
//
//        expect(sut, toCompleteWith: .failure(deletionError), when: {
//            store.completeRetrieval(with: anyNSError())
//            store.completeDeletion(with: deletionError)
//        })
//    }
//
//    func test_validateCache_succeedsOnSuccessfulDeletionOfFailedRetrieval() {
//        let (sut, store) = makeSUT()
//
//        expect(sut, toCompleteWith: .success(()), when: {
//            store.completeRetrieval(with: anyNSError())
//            store.completeDeletionSuccessfully()
//        })
//    }
//    
////    func test_validateCache_succeedsOnEmptyCache() {
////        let (sut, store) = makeSUT()
////
////        expect(sut, toCompleteWith: .success(()), when: {
////            store.completeRetrievalWithEmptyCache()
////        })
////    }
//    
//    func test_validateCache_succeedsOnNonExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//
//        expect(sut, toCompleteWith: .success(()), when: {
//            store.completeRetrieval(with: teams.local, timestamp: nonExpiredTimestamp)
//        })
//    }
//    
//    func test_validateCache_failsOnDeletionErrorOfExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        let deletionError = anyNSError()
//
//        expect(sut, toCompleteWith: .failure(deletionError), when: {
//            store.completeRetrieval(with: teams.local, timestamp: expiredTimestamp)
//            store.completeDeletion(with: deletionError)
//        })
//    }
//
//    func test_validateCache_succeedsOnSuccessfulDeletionOfExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//
//        expect(sut, toCompleteWith: .success(()), when: {
//            store.completeRetrieval(with: teams.local, timestamp: expiredTimestamp)
//            store.completeDeletionSuccessfully()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTeamLoader, store: TeamStoreSpy) {
//        let store = TeamStoreSpy()
//        let sut = LocalTeamLoader(store: store, currentDate: currentDate)
//        trackForMemoryLeaks(store, file: file, line: line)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        return (sut, store)
//    }
//    
//    private func expect(_ sut: LocalTeamLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
//        action()
//        
//        let receivedResult = Result { try sut.validateCache() }
//        
//        switch (receivedResult, expectedResult) {
//        case (.success, .success):
//            break
//            
//        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
//            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
//            
//        default:
//            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
//        }
//    }
//}
