//
//  CoreDataImageStoreTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 24/3/25.
//

import XCTest
@testable import LigasEcApp

class CoreDataImageStoreTests: XCTestCase, ImageStoreSpecs {
    func test_retrieveLeagueImageData_deliversLastInsertedValue() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveLeagueImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveLeagueImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveLeagueImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
        }
    }

    func test_retrieveLeagueImageData_deliversNotFoundWhenEmpty() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveLeagueImageDataDeliversNotFoundOnEmptyCache(on: sut, imageDataURL: imageDataURL)
        }
    }

    func test_retrieveLeagueImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveLeagueImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveTeamImageData_deliversNotFoundWhenEmpty() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveTeamImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveTeamImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveTeamImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveTeamImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveTeamImageDataDeliversNotFoundOnEmptyCache(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveTeamImageData_deliversLastInsertedValue() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveTeamImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataLigasEcStore, URL) -> Void, file: StaticString = #filePath, line: UInt = #line) throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataLigasEcStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        let exp = expectation(description: "wait for operation")
        sut.perform {
            let imageDataURL = URL(string: "http://a-url.com")!
            insertLeague(with: imageDataURL, into: sut, file: file, line: line)
            insertTeam(with: imageDataURL, into: sut, file: file, line: line)
            test(sut, imageDataURL)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
}

private func insertLeague(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) {
    do {
        let league = LocalLeague(id: "id", name: "LigaPro Serie A", logoURL: url)
        try sut.insert([league], timestamp: Date())
    } catch {
        XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
    }
}

private func insertTeam(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) {
    do {
        let team = LocalTeam(id: "id", name: "Barcelona SC", logoURL: url)
        try sut.insert([team], with: "id")
    } catch {
        XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
    }
}
