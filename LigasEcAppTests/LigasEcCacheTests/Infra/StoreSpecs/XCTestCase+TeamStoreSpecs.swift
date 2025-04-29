//
//  XCTestCase+TeamStoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 26/3/25.
//

import XCTest
import LigasEcApp

extension TeamStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversNoErrorOnEmptyCache(on sut: TeamStore, with id: String, file: StaticString = #filePath, line: UInt = #line) async {
        // Act & Assert
        await expect(sut, with: id, toRetrieve: .success(.none), file: file, line: line)
    }
        
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: TeamStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        
        // Act
        await insert(mockTeams().local, with: id, to: sut)
        
        // Act & Assert
        await expect(sut, with: id, toRetrieve: .success(mockTeams().local), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: TeamStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        
        // Act
        await insert(mockTeams().local, with: id, to: sut)

        // Act & Assert
        await expect(sut, with: id, toRetrieveTwice: .success(mockTeams().local), file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: TeamStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        // Act
        let insertionError = await insert((mockTeams().local), with: id, to: sut)
        
        // Assert
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: TeamStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await insert((mockTeams().local), with: id, to: sut)

        let insertionError = await insert((mockTeams().local), with: id, to: sut)
   
        //Assert
        XCTAssertNil(insertionError, "Expected to insert just once without error", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: TeamStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await insert([LocalTeam(id: "id",
                          name: "LDU",
                          logoURL: anyURL())], with: id, to: sut)
        
        await insert((mockTeams().local), with: id, to: sut)
   
        //Assert
        await expect(sut, with: id, toRetrieve: .success(mockTeams().local))
    }
                
    @discardableResult
    func insert(_ teams: [LocalTeam], with id: String, to sut: TeamStore) async -> Error? {
        do {
            // Act
            try await sut.insert(teams, with: id)
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: TeamStore, with id: String, toRetrieveTwice expectedResult: Result<[LocalTeam]?, Error>, file: StaticString = #filePath, line: UInt = #line) async {
        await expect(sut, with: id, toRetrieve: expectedResult, file: file, line: line)
        await expect(sut, with: id, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: TeamStore, with id: String, toRetrieve expectedResult: Result<[LocalTeam]?, Error>, file: StaticString = #filePath, line: UInt = #line) async {
        
        // Act
        let retrievedResult: Result<[LocalTeam]?, Error>
        
        do {
            let retrievedTeams = try await sut.retrieve(with: id)
            retrievedResult = .success(retrievedTeams)
        } catch {
            retrievedResult = .failure(error)
        }

        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
             (.failure, .failure):
            break

        case let (.success(.some(expected)), .success(.some(retrieved))):
            // Assert
            XCTAssertEqual(retrieved, expected, file: file, line: line)

        default:
            // Assert
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
