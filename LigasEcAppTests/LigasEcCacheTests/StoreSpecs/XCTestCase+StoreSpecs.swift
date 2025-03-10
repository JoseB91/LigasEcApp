//
//  XCTestCase+StoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

import XCTest
import LigasEcApp

extension StoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        let teams = mockTeams().local
        let timestamp = Date()
        
        insert((teams, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedTeams(teams: teams, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        let teams = mockTeams().local
        let timestamp = Date()
        
        insert((teams, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedTeams(teams: teams, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((mockTeams().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockTeams().local, Date()), to: sut)
        
        let insertionError = insert((mockTeams().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockTeams().local, Date()), to: sut)
        
        let latestTeams = mockTeams().local
        let latestTimestamp = Date()
        insert((latestTeams, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedTeams(teams: latestTeams, timestamp: latestTimestamp)), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockTeams().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: TeamStore, file: StaticString = #file, line: UInt = #line) {
        insert((mockTeams().local, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
        
    @discardableResult
    func insert(_ cache: (teams: [LocalTeam], timestamp: Date), to sut: TeamStore) -> Error? {
        do {
            try sut.insert(cache.teams, timestamp: cache.timestamp)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func deleteCache(from sut: TeamStore) -> Error? {
        do {
            try sut.delete()
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: TeamStore, toRetrieveTwice expectedResult: Result<CachedTeams?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    func expect(_ sut: TeamStore, toRetrieve expectedResult: Result<CachedTeams?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        
        let retrievedResult = Result { try sut.retrieve() }

        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
             (.failure, .failure):
            break

        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved.teams, expected.teams, file: file, line: line)
            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)

        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
