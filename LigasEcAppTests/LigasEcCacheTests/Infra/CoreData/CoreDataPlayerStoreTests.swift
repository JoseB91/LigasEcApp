//
//  CoreDataPlayerStoreTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 29/4/25.
//

import XCTest
@testable import LigasEcApp

class CoreDataPlayerStoreTests: XCTestCase, PlayerStoreSpecs {
    func test_retrieve_deliversNoErrorOnEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatRetrieveDeliversNoErrorOnEmptyCache(on: sut, with: "id")
        }
    }
        
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut, leagueStore: sut, teamStore: sut, with: "pCMG6CNp")
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut, leagueStore: sut, teamStore: sut, with: "pCMG6CNp")
        }
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatInsertDeliversNoErrorOnEmptyCache(on: sut, with: "id")
        }
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut, with: "id")
        }
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() async throws {
        try await makeSUT { sut in
            await self.assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut, leagueStore: sut, teamStore: sut, with: "pCMG6CNp")
        }
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataLigasEcStore) async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataLigasEcStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)

        try await withCheckedThrowingContinuation { continuation in
            sut.context.perform {
                Task {
                    do {
                        try await test(sut)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    

}
