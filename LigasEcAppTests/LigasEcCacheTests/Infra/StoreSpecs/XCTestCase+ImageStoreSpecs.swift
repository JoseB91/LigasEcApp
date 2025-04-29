//
//  XCTestCase+ImageStoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 12/3/25.
//

import XCTest
import Foundation
import LigasEcApp

extension ImageStoreSpecs where Self: XCTestCase {

    func assertThatRetrieveLeagueImageDataDeliversNotFoundOnEmptyCache(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Act &  Assert
        await expect(sut, table: mockLeagueTable(), toCompleteRetrievalWith: notFound(), for: imageDataURL, file: file, line: line)
    }

    func assertThatRetrieveLeagueImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let nonMatchingURL = URL(string: "http://a-non-matching-url.com")!

        // Act
        await insert(anyData(), table: mockLeagueTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Act &  Assert
        await expect(sut, table: mockLeagueTable(), toCompleteRetrievalWith: notFound(), for: nonMatchingURL, file: file, line: line)
    }

    func assertThatRetrieveLeagueImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let storedData = anyData()

        // Act
        await insert(storedData, table: mockLeagueTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Act &  Assert
        await expect(sut, table: mockLeagueTable(), toCompleteRetrievalWith: found(storedData), for: imageDataURL, file: file, line: line)
    }

    func assertThatRetrieveLeagueImageDataDeliversLastInsertedValueForURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)

        // Act
        await insert(firstStoredData, table: mockLeagueTable(), for: imageDataURL, into: sut, file: file, line: line)
        await insert(lastStoredData, table: mockLeagueTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Assert
        await expect(sut, table: mockLeagueTable(), toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL, file: file, line: line)
    }
    
    func assertThatRetrieveTeamImageDataDeliversNotFoundOnEmptyCache(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Act &  Assert
        await expect(sut, table: mockTeamTable(), toCompleteRetrievalWith: notFound(), for: imageDataURL, file: file, line: line)
    }

    func assertThatRetrieveTeamImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let nonMatchingURL = URL(string: "http://a-non-matching-url.com")!

        // Act
        await insert(anyData(), table: mockTeamTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Act &  Assert
        await expect(sut, table: mockTeamTable(), toCompleteRetrievalWith: notFound(), for: nonMatchingURL, file: file, line: line)
    }

    func assertThatRetrieveTeamImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let storedData = anyData()

        // Act
        await insert(storedData, table: mockTeamTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Act &  Assert
        await expect(sut, table: mockTeamTable(), toCompleteRetrievalWith: found(storedData), for: imageDataURL, file: file, line: line)
    }

    func assertThatRetrieveTeamImageDataDeliversLastInsertedValueForURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)

        // Act
        await insert(firstStoredData, table: mockTeamTable(), for: imageDataURL, into: sut, file: file, line: line)
        await insert(lastStoredData, table: mockTeamTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Assert
        await expect(sut, table: mockTeamTable(), toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL, file: file, line: line)
    }
}

extension ImageStoreSpecs where Self: XCTestCase {

    func notFound() -> Result<Data?, Error> {
        .success(.none)
    }

    func found(_ data: Data) -> Result<Data?, Error> {
        .success(data)
    }

    func expect(_ sut: ImageStore, table: Table, toCompleteRetrievalWith expectedResult: Result<Data?, Error>, for url: URL,  file: StaticString = #filePath, line: UInt = #line) async {
        // Act
        let receivedResult: Result<Data?, Error>
        
        do {
            let retrievedData = try await sut.retrieve(dataFor: url, on: table)
            receivedResult = .success(retrievedData)
        } catch {
            receivedResult = .failure(error)
        }

        switch (receivedResult, expectedResult) {
        case let (.success( receivedData), .success(expectedData)):
            // Assert
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)

        default:
            // Assert
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }

    func insert(_ data: Data, table: Table, for url: URL, into sut: ImageStore, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            // Act
            try await sut.insert(data, for: url, on: table)
        } catch {
            // Assert
            XCTFail("Failed to insert image data: \(data) - error: \(error)", file: file, line: line)
        }
    }

}
