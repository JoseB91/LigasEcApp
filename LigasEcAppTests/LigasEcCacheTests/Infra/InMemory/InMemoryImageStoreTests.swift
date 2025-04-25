////
////  InMemoryImageStoreTests.swift
////  LigasEcAppTests
////
////  Created by José Briones on 12/3/25.
////
//
//import XCTest
//@testable import LigasEcApp
//
//class InMemoryImageStoreTests: XCTestCase, ImageStoreSpecs {
//
//    func test_retrieveLeagueImageData_deliversLastInsertedValue() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveLeagueImageDataDeliversLastInsertedValueForURL(on: sut)
//    }
//    
//    func test_retrieveLeagueImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveLeagueImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
//    }
//    
//    func test_retrieveLeagueImageData_deliversNotFoundWhenEmpty() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveLeagueImageDataDeliversNotFoundOnEmptyCache(on: sut)
//    }
//
//    func test_retrieveLeagueImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveLeagueImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
//    }
//
//    func test_retrieveTeamImageData_deliversLastInsertedValue() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveTeamImageDataDeliversLastInsertedValueForURL(on: sut)
//    }
//    
//    func test_retrieveTeamImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveTeamImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
//    }
//    
//    func test_retrieveTeamImageData_deliversNotFoundWhenEmpty() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveTeamImageDataDeliversNotFoundOnEmptyCache(on: sut)
//    }
//
//    func test_retrieveTeamImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
//        let sut = makeSUT()
//
//        assertThatRetrieveTeamImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
//    }
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
