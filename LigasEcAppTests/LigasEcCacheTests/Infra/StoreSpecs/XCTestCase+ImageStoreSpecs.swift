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

    //MARK: LEAGUE
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
        let storedData = mockLeagueData()

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
        let lastStoredData = mockLeagueData()

        // Act
        await insert(firstStoredData, table: mockLeagueTable(), for: imageDataURL, into: sut, file: file, line: line)
        await insert(lastStoredData, table: mockLeagueTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Assert
        await expect(sut, table: mockLeagueTable(), toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL, file: file, line: line)
    }
    
    //MARK: TEAM
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
        let storedData = mockTeamData()

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
        let lastStoredData = mockTeamData()

        // Act
        await insert(firstStoredData, table: mockTeamTable(), for: imageDataURL, into: sut, file: file, line: line)
        await insert(lastStoredData, table: mockTeamTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Assert
        await expect(sut, table: mockTeamTable(), toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL, file: file, line: line)
    }
    
    //MARK: PLAYER
    func assertThatRetrievePlayerImageDataDeliversNotFoundOnEmptyCache(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Act &  Assert
        await expect(sut, table: mockPlayerTable(), toCompleteRetrievalWith: notFound(), for: imageDataURL, file: file, line: line)
    }

    func assertThatRetrievePlayerImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let nonMatchingURL = URL(string: "http://a-non-matching-url.com")!

        // Act
        await insert(anyData(), table: mockPlayerTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Act &  Assert
        await expect(sut, table: mockPlayerTable(), toCompleteRetrievalWith: notFound(), for: nonMatchingURL, file: file, line: line)
    }

    func assertThatRetrievePlayerImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let storedData = mockPlayerData()

        // Act
        await insert(storedData, table: mockPlayerTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Act &  Assert
        await expect(sut, table: mockPlayerTable(), toCompleteRetrievalWith: found(storedData), for: imageDataURL, file: file, line: line)
    }

    func assertThatRetrievePlayerImageDataDeliversLastInsertedValueForURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        // Arrange
        let firstStoredData = Data("first".utf8)
        let lastStoredData = mockPlayerData()

        // Act
        await insert(firstStoredData, table: mockPlayerTable(), for: imageDataURL, into: sut, file: file, line: line)
        await insert(lastStoredData, table: mockPlayerTable(), for: imageDataURL, into: sut, file: file, line: line)

        // Assert
        await expect(sut, table: mockPlayerTable(), toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL, file: file, line: line)
    }
}

extension ImageStoreSpecs where Self: XCTestCase {

    func notFound() -> Result<Data?, Error> {
        .success(.none)
    }

    func found(_ data: Data) -> Result<Data?, Error> {
        .success(data)
    }
    
    func mockLeagueData() -> Data {
        Data(base64Encoded: "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")!
    }
    
    func mockTeamData() -> Data {
        return Data(base64Encoded: "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")!
    }
    
    func mockPlayerData() -> Data {
        Data(base64Encoded: "")!
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
