//
//  CoreDataImageStoreTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 24/3/25.
//

import XCTest
@testable import LigasEcApp

class CoreDataImageStoreTests: XCTestCase, ImageStoreSpecs {
    
    // MARK: League
    func test_retrieveLeagueImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        try await makeSUT { sut, imageDataURL, _, _ in
            await self.assertThatRetrieveLeagueImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    func test_retrieveLeagueImageData_deliversLastInsertedValue() async throws {
        try await makeSUT { sut, imageDataURL, _, _ in
            await self.assertThatRetrieveLeagueImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    func test_retrieveLeagueImageData_deliversNotFoundWhenEmpty() async throws {
        try await makeSUT { sut, imageDataURL, _, _ in
            await self.assertThatRetrieveLeagueImageDataDeliversNotFoundOnEmptyCache(on: sut)
            await self.deleteCache(sut: sut)
        }
    }

    func test_retrieveLeagueImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        try await makeSUT { sut, imageDataURL, _, _ in
            await self.assertThatRetrieveLeagueImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    // MARK: Team
    func test_retrieveTeamImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        try await makeSUT { sut, _, imageDataURL, _ in
            await self.assertThatRetrieveTeamImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    func test_retrieveTeamImageData_deliversLastInsertedValue() async throws {
        try await makeSUT { sut, _, imageDataURL, _ in
            await self.assertThatRetrieveTeamImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    func test_retrieveTeamImageData_deliversNotFoundWhenEmpty() async throws {
        try await makeSUT { sut, _, imageDataURL, _ in
            await self.assertThatRetrieveTeamImageDataDeliversNotFoundOnEmptyCache(on: sut)
            await self.deleteCache(sut: sut)
        }
    }
    
    func test_retrieveTeamImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        try await makeSUT { sut, _, imageDataURL, _ in
            await self.assertThatRetrieveTeamImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    // MARK: Player
    func test_retrievePlayerImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        try await makeSUT { sut, _, _, imageDataURL in
            await self.assertThatRetrievePlayerImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    func test_retrievePlayerImageData_deliversLastInsertedValue() async throws {
        try await makeSUT { sut, _, _, imageDataURL in
            await self.assertThatRetrievePlayerImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }

    func test_retrievePlayerImageData_deliversNotFoundWhenEmpty() async throws {
        try await makeSUT { sut, _, _, imageDataURL in
            await self.assertThatRetrievePlayerImageDataDeliversNotFoundOnEmptyCache(on: sut)
            await self.deleteCache(sut: sut)
        }
    }
    
    func test_retrievePlayerImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        try await makeSUT { sut, _, _, imageDataURL in
            await self.assertThatRetrievePlayerImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
            await self.deleteCache(sut: sut)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataLigasEcStore, URL, URL, URL) async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataLigasEcStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        try await withCheckedThrowingContinuation { continuation in
            sut.context.perform {
                Task {
                    do {
                        let leagueImageDataURL = URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!
                        let teamImageDataURL = URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!
                        let playerImageDataURL = URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!
                        await self.insertLeague(with: leagueImageDataURL, into: sut, file: file, line: line)
                        await self.insertTeam(with: teamImageDataURL, into: sut, file: file, line: line)
                        await self.insertPlayer(with: playerImageDataURL, into: sut, file: file, line: line)
                        try await test(sut, leagueImageDataURL, teamImageDataURL, playerImageDataURL)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func deleteCache(sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            try await sut.deleteCache()
        } catch {
            XCTFail("Failed to delete cache")
        }
    }
    
    private func insertLeague(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let league = LocalLeague(id: "IaFDigtm", name: "LigaPro Serie A", logoURL: url)
            try await sut.insert([league], timestamp: Date())
        } catch {
            XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
        }
    }

    private func insertTeam(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let team = LocalTeam(id: "pCMG6CNp", name: "Barcelona SC", logoURL: url)
            try await sut.insert([team], with: "IaFDigtm")
        } catch {
            XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
        }
    }

    private func insertPlayer(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let player = LocalPlayer(id: "S0nWKdXm",
                                     name: "Contreras Jose",
                                     number: 1,
                                     position: "Portero",
                                     flagId: 205,
                                     photoURL: url)
            try await sut.insert([player], with: "pCMG6CNp")
        } catch {
            XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
        }
    }
}
