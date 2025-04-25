////
////  CoreDataTeamStoreTests.swift
////  LigasEcAppTests
////
////  Created by José Briones on 26/3/25.
////
//
//import XCTest
//@testable import LigasEcApp
//
//class CoreDataTeamStoreTests: XCTestCase, TeamStoreSpecs {
//    func test_retrieve_deliversNoErrorOnEmptyCache() throws {
//        try makeSUT { sut in
//            self.assertThatRetrieveDeliversNoErrorOnEmptyCache(on: sut, with: "id")
//        }
//    }
//        
//    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
////        try makeSUT { sut in
////            self.assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut, with: "id")
////        }
//    }
//    
//    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
////        try makeSUT { sut in
////            self.assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut, with: "id")
////        }
//    }
//    
//    func test_insert_deliversNoErrorOnEmptyCache() throws {
//        try makeSUT { sut in
//            self.assertThatInsertDeliversNoErrorOnEmptyCache(on: sut, with: "id")
//        }
//    }
//    
//    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
//        try makeSUT { sut in
//            self.assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut, with: "id")
//        }
//    }
//    
//    func test_insert_overridesPreviouslyInsertedCacheValues() throws {
////        try makeSUT { sut in
////            self.assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut, with: "id")
////        }
//    }
//    
//    // - MARK: Helpers
//    
//    private func makeSUT(_ test: @escaping (CoreDataLigasEcStore) -> Void, file: StaticString = #filePath, line: UInt = #line) throws {
//        let storeURL = URL(fileURLWithPath: "/dev/null")
//        let sut = try CoreDataLigasEcStore(storeURL: storeURL)
//        trackForMemoryLeaks(sut, file: file, line: line)
//
//        let exp = expectation(description: "wait for operation")
//        sut.perform {
//            test(sut)
//            exp.fulfill()
//        }
//        wait(for: [exp], timeout: 0.1)
//    }
//    
//
//}
