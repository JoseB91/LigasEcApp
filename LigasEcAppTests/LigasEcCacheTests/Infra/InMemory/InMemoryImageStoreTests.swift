//
//  InMemoryImageStoreTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 12/3/25.
//

import XCTest
@testable import LigasEcApp

class InMemoryImageStoreTests: XCTestCase, ImageStoreSpecs {

    func test_retrieveImageData_deliversLastInsertedValue() throws {
        let sut = makeSUT()

        assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        let sut = makeSUT()

        assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        let sut = makeSUT()

        assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }

    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        let sut = makeSUT()

        assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }

    // - MARK: Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> InMemoryStore {
        let sut = InMemoryStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
