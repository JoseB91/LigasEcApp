//
//  XCTestCase+StoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

import XCTest
import LigasEcApp

extension LeagueStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: LeagueStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        let leagues = mockLeagues().local
        let timestamp = Date()
        
        insert((leagues, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedLeagues(leagues: leagues, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        let leagues = mockLeagues().local
        let timestamp = Date()
        
        insert((leagues, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedLeagues(leagues: leagues, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((mockLeagues().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockLeagues().local, Date()), to: sut)
        
        let insertionError = insert((mockLeagues().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockLeagues().local, Date()), to: sut)
        
        let latestLeagues = mockLeagues().local
        let latestTimestamp = Date()
        insert((latestLeagues, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedLeagues(leagues: latestLeagues, timestamp: latestTimestamp)), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockLeagues().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockLeagues().local, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
        
    @discardableResult
    func insert(_ cache: (leagues: [LocalLeague], timestamp: Date), to sut: LeagueStore) -> Error? {
        do {
            try sut.insert(cache.leagues, timestamp: cache.timestamp)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func deleteCache(from sut: LeagueStore) -> Error? {
        do {
            try sut.deleteCache()
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: LeagueStore, toRetrieveTwice expectedResult: Result<CachedLeagues?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    func expect(_ sut: LeagueStore, toRetrieve expectedResult: Result<CachedLeagues?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        
        let retrievedResult = Result { try sut.retrieve() }

        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
             (.failure, .failure):
            break

        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved.leagues, expected.leagues, file: file, line: line)
            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)

        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
