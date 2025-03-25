//
//  CoreDataLeagueStoreTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 24/3/25.
//
import XCTest
@testable import LigasEcApp
class CoreDataLeagueStoreTests: XCTestCase, LeagueStoreSpecs {
    
    func test_insert_deliversNoErrorOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
        }
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    }
    
    func test_insert_doNotSaveOnNonEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatInsertDoNotSaveOnNonEmptyCache(on: sut)
        }
    }

    func test_delete_deliversNoErrorOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
        }
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() throws {
        try makeSUT { sut in
            self.assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
        }
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataLigasEcStore) -> Void, file: StaticString = #filePath, line: UInt = #line) throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataLigasEcStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)

        let exp = expectation(description: "wait for operation")
        sut.perform {
            test(sut)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

}
