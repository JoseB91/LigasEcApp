//
//  InMemoryTeamStoreTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 26/3/25.
//

import XCTest
@testable import LigasEcApp

class InMemoryTeamStoreTests: XCTestCase, TeamStoreSpecs {
    
    func test_retrieve_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()
        await assertThatRetrieveDeliversNoErrorOnEmptyCache(on: sut, with: "id")
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() async throws {
        let sut = makeSUT()
        await assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut, and: sut, with: "id")
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async throws {
        let sut = makeSUT()
        await assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut, and: sut, with: "id")
    }
        
    func test_insert_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()
        await assertThatInsertDeliversNoErrorOnEmptyCache(on: sut, with: "id")
    }

    func test_insert_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()
        await assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut, with: "id")
    }

    func test_insert_overridesPreviouslyInsertedCacheValues() async throws {
        let sut = makeSUT()
        await assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut, and: sut, with: "id")
    }
    
    // - MARK: Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> InMemoryStore {
        let sut = InMemoryStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

