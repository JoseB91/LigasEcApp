////
////  XCTestCase+StoreSpecs.swift
////  LigasEcAppTests
////
////  Created by José Briones on 10/3/25.
////
//
//import XCTest
//import LigasEcApp
//
//extension LeagueStoreSpecs where Self: XCTestCase {    
//    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
//        // Act
//        let insertionError = insert((mockLeagues().local, Date()), to: sut)
//        
//        // Assert
//        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
//    }
//    
//    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
//        // Act
//        insert((mockLeagues().local, Date()), to: sut)
//                
//        let insertionError = insert((mockLeagues().local, Date()), to: sut)
//   
//        //Assert
//        XCTAssertNil(insertionError, "Expected to insert just once without error", file: file, line: line)
//    }
//    
//    func assertThatInsertDoNotSaveOnNonEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
//        // Act
//        let timestamp = Date()
//        insert((mockLeagues().local, timestamp), to: sut)
//                
//        insert(([LocalLeague(id: "id",                             
//                             name: "LigaPro Serie B",
//                             logoURL: anyURL())], Date()), to: sut)
//   
//        //Assert
//        expect(sut, toRetrieve: .success(CachedLeagues(leagues: mockLeagues().local, timestamp: timestamp)))
//    }
//        
//    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
//        // Act
//        let deletionError = deleteCache(from: sut)
//        
//        // Assert
//        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
//    }
//    
//    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
//        // Act
//        deleteCache(from: sut)
//        
//        // Assert
//        expect(sut, toRetrieve: .success(.none), file: file, line: line)
//    }
//    
//    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
//        // Act
//        insert((mockLeagues().local, Date()), to: sut)
//        let deletionError = deleteCache(from: sut)
//        
//        // Assert
//        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
//    }
//    
//    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: LeagueStore, file: StaticString = #file, line: UInt = #line) {
//        // Act
//        insert((mockLeagues().local, Date()), to: sut)
//        deleteCache(from: sut)
//        
//        // Assert
//        expect(sut, toRetrieve: .success(.none), file: file, line: line)
//    }
//        
//    @discardableResult
//    func insert(_ cache: (leagues: [LocalLeague], timestamp: Date), to sut: LeagueStore) -> Error? {
//        do {
//            // Act
//            try sut.insert(cache.leagues, timestamp: cache.timestamp)
//            return nil
//        } catch {
//            return error
//        }
//    }
//    
//    @discardableResult
//    func deleteCache(from sut: LeagueStore) -> Error? {
//        do {
//            // Act
//            try sut.deleteCache()
//            return nil
//        } catch {
//            return error
//        }
//    }
//    func expect(_ sut: LeagueStore, toRetrieve expectedResult: Result<CachedLeagues?, Error>, file: StaticString = #filePath, line: UInt = #line) {
//        
//        // Act
//        let retrievedResult = Result { try sut.retrieve() }
//
//        switch (expectedResult, retrievedResult) {
//        case (.success(.none), .success(.none)),
//             (.failure, .failure):
//            break
//
//        case let (.success(.some(expected)), .success(.some(retrieved))):
//            // Assert
//            XCTAssertEqual(retrieved.leagues, expected.leagues, file: file, line: line)
//            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
//
//        default:
//            // Assert
//            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
//        }
//    }
//}
