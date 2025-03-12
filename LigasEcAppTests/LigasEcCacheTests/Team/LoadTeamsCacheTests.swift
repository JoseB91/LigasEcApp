////
////  LoadTeamsCacheTests.swift
////  LigasEcAppTests
////
////  Created by José Briones on 10/3/25.
////
//
//import XCTest
//import LigasEcAPI
//@testable import LigasEcApp
//
//final class LoadTeamsCacheTests: XCTestCase {
//
//    func test_init_doesNotMessageStoreUponCreation() {
//        let (_, store) = makeSUT()
//        
//        XCTAssertEqual(store.receivedMessages, [])
//    }
//    
//    func test_load_requestsCacheRetrieval() {
//        let (sut, store) = makeSUT()
//        
//        _ = try? sut.load()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//    }
//    
//    func test_load_failsOnRetrievalError() {
//        let (sut, store) = makeSUT()
//        let retrievalError = anyNSError()
//
//        expect(sut, toCompleteWith: .failure(retrievalError), when: {
//            store.completeRetrieval(with: retrievalError)
//        })
//    }
//    
//    func test_load_failsOnEmptyCache() {
//        let (sut, store) = makeSUT()
//        let retrievalError = anyNSError()
//
//        expect(sut, toCompleteWith: .failure(retrievalError), when: {
//            store.completeRetrieval(with: retrievalError)
//        })
//    }
//    
//    func test_load_deliversCachedTeamsOnNonExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        
//        expect(sut, toCompleteWith: .success(teams.models), when: {
//            store.completeRetrieval(with: teams.local, timestamp: nonExpiredTimestamp)
//        })
//    }
//    
////    func test_load_failsOnCacheExpiration() { // TODO: Review this, it should be deleting cache and save teams for url calls
////        let teams = mockTeams()
////        let fixedCurrentDate = Date()
////        let retrievalError = anyNSError()
////        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
////        
////        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
////        
////        expect(sut, toCompleteWith: .failure(retrievalError) , when: {
////            store.completeRetrieval(with: retrievalError)
////        })
////    }
////    
////    func test_load_deliversNoTeamsOnExpiredCache() {
////        let teams = mockTeams()
////        let fixedCurrentDate = Date()
////        let retrievalError = anyNSError()
////        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
////        
////        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
////        
////        expect(sut, toCompleteWith: .failure(retrievalError) , when: {
////            store.completeRetrieval(with: teams.local, timestamp: expiredTimestamp)
////        })
////    }
//    
//    func test_load_hasNoSideEffectsOnRetrievalError() {
//        let (sut, store) = makeSUT()
//        store.completeRetrieval(with: anyNSError())
//        
//        _ = try? sut.load()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//    }
//    
//    func test_load_hasNoSideEffectsOnNonExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        store.completeRetrieval(with: teams.local, timestamp: nonExpiredTimestamp)
//        
//        _ = try? sut.load()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//    }
//    
//    func test_load_hasNoSideEffectsOnCacheExpiration() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        store.completeRetrieval(with: teams.local, timestamp: expirationTimestamp)
//        
//        _ = try? sut.load()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//    }
//    
//    func test_load_hasNoSideEffectsOnExpiredCache() {
//        let teams = mockTeams()
//        let fixedCurrentDate = Date()
//        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
//        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
//        store.completeRetrieval(with: teams.local, timestamp: expiredTimestamp)
//
//        _ = try? sut.load()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
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
//    private func expect(_ sut: LocalTeamLoader, toCompleteWith expectedResult: Result<[Team], Error>, when action: () -> Void?, file: StaticString = #filePath, line: UInt = #line) {
//        action()
//        
//        let receivedResult = Result { try sut.load() }
//        
//        switch (receivedResult, expectedResult) {
//        case let (.success(receivedImages), .success(expectedImages)):
//            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
//            
//        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
//            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
//            
//        default:
//            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
//        }
//    }
//}
