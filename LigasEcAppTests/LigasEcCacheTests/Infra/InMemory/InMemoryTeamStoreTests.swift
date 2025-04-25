////
////  InMemoryTeamStoreTests.swift
////  LigasEcAppTests
////
////  Created by José Briones on 26/3/25.
////
//
//import XCTest
//@testable import LigasEcApp
//
//class InMemoryTeamStoreTests: XCTestCase, TeamStoreSpecs {
//    func test_retrieve_deliversNoErrorOnEmptyCache() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveDeliversNoErrorOnEmptyCache(on: sut, with: "id")
//    }
//    
//    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut, with: "id")
//    }
//    
//    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut, with: "id")
//    }
//        
//    func test_insert_deliversNoErrorOnEmptyCache() throws {
//        let sut = makeSUT()
//
//        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut, with: "id")
//    }
//
//    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
//        let sut = makeSUT()
//
//        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut, with: "id")
//    }
//    
//    func test_insert_overridesPreviouslyInsertedCacheValues() throws {
//        let sut = makeSUT()
//
//        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut, with: "id")
//    }
//    
//
//    // - MARK: Helpers
//
//    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> InMemoryStore {
//        let sut = InMemoryStore()
//        trackForMemoryLeaks(sut, file: file, line: line)
//        return sut
//    }
//
//}
//
