//
//  InMemoryImageStoreTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 12/3/25.
//

import XCTest
@testable import LigasEcApp

class InMemoryImageStoreTests: XCTestCase, ImageStoreSpecs {
    
    func test_retrieveLeagueImageData_deliversLastInsertedValue() async throws {
        let sut = makeSUT()
        await assertThatRetrieveLeagueImageDataDeliversLastInsertedValueForURL(on: sut)
    }

    func test_retrieveLeagueImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        let sut = makeSUT()
        await assertThatRetrieveLeagueImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }

    func test_retrieveLeagueImageData_deliversNotFoundWhenEmpty() async throws {
        let sut = makeSUT()
        await assertThatRetrieveLeagueImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }

    func test_retrieveLeagueImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        let sut = makeSUT()
        await assertThatRetrieveLeagueImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }

    func test_retrieveTeamImageData_deliversLastInsertedValue() async throws {
        let sut = makeSUT()
        await assertThatRetrieveTeamImageDataDeliversLastInsertedValueForURL(on: sut)
    }

    func test_retrieveTeamImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        let sut = makeSUT()
        await assertThatRetrieveTeamImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }

    func test_retrieveTeamImageData_deliversNotFoundWhenEmpty() async throws {
        let sut = makeSUT()
        await assertThatRetrieveTeamImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }

    func test_retrieveTeamImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        let sut = makeSUT()
        await assertThatRetrieveTeamImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }
    
    func test_retrievePlayerImageData_deliversLastInsertedValue() async throws {
        let sut = makeSUT()
        await assertThatRetrievePlayerImageDataDeliversLastInsertedValueForURL(on: sut)
    }

    func test_retrievePlayerImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        let sut = makeSUT()
        await assertThatRetrievePlayerImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }

    func test_retrievePlayerImageData_deliversNotFoundWhenEmpty() async throws {
        let sut = makeSUT()
        await assertThatRetrievePlayerImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }

    func test_retrievePlayerImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        let sut = makeSUT()
        await assertThatRetrievePlayerImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }
        
    // - MARK: Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> InMemoryStore {
        let sut = InMemoryStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
