//
//  XCTestCase+PlayerStoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 28/4/25.
//

import XCTest
import LigasEcApp

extension PlayerStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversNoErrorOnEmptyCache(on sut: PlayerStore, with id: String, file: StaticString = #filePath, line: UInt = #line) async {
        // Act & Assert
        await expect(sut, with: id, toRetrieve: .success(.none), file: file, line: line)
    }
        
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: PlayerStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        
        // Act
        await insert(mockPlayers().local, with: id, to: sut)
        
        // Act & Assert
        await expect(sut, with: id, toRetrieve: .success(mockPlayers().local), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: PlayerStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        
        // Act
        await insert(mockPlayers().local, with: id, to: sut)

        // Act & Assert
        await expect(sut, with: id, toRetrieveTwice: .success(mockPlayers().local), file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: PlayerStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        // Act
        let insertionError = await insert((mockPlayers().local), with: id, to: sut)
        
        // Assert
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: PlayerStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await insert((mockPlayers().local), with: id, to: sut)

        let insertionError = await insert((mockPlayers().local), with: id, to: sut)
   
        //Assert
        XCTAssertNil(insertionError, "Expected to insert just once without error", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: PlayerStore, with id: String, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await insert([LocalPlayer(id: "1",
                                  name: "Alexander Dominguez",
                                  number: 1,
                                  position: "Portero",
                                  photoURL: anyURL())], with: id, to: sut)
        
        await insert((mockPlayers().local), with: id, to: sut)
   
        //Assert
        await expect(sut, with: id, toRetrieve: .success(mockPlayers().local))
    }
                
    @discardableResult
    func insert(_ players: [LocalPlayer], with id: String, to sut: PlayerStore) async -> Error? {
        do {
            // Act
            try await sut.insert(players, with: id)
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: PlayerStore, with id: String, toRetrieveTwice expectedResult: Result<[LocalPlayer]?, Error>, file: StaticString = #filePath, line: UInt = #line) async {
        await expect(sut, with: id, toRetrieve: expectedResult, file: file, line: line)
        await expect(sut, with: id, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: PlayerStore, with id: String, toRetrieve expectedResult: Result<[LocalPlayer]?, Error>, file: StaticString = #filePath, line: UInt = #line) async {
        
        // Act
        let retrievedResult: Result<[LocalPlayer]?, Error>
        
        do {
            let retrievedPlayers = try await sut.retrieve(with: id)
            retrievedResult = .success(retrievedPlayers)
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
