////
////  CoreDataImageStoreTests.swift
////  LigasEcAppTests
////
////  Created by José Briones on 24/3/25.
////
//
//import XCTest
//@testable import LigasEcApp
//
////TODO: Review tests
//class CoreDataImageStoreTests: XCTestCase, ImageStoreSpecs {
//    // MARK: League
//    func test_retrieveLeagueImageData_deliversLastInsertedValue() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveLeagueImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    func test_retrieveLeagueImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveLeagueImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//
//    func test_retrieveLeagueImageData_deliversNotFoundWhenEmpty() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveLeagueImageDataDeliversNotFoundOnEmptyCache(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//
//    func test_retrieveLeagueImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveLeagueImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    // MARK: Team
//    func test_retrieveTeamImageData_deliversNotFoundWhenEmpty() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveTeamImageDataDeliversNotFoundOnEmptyCache(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    func test_retrieveTeamImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveTeamImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    func test_retrieveTeamImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveTeamImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    func test_retrieveTeamImageData_deliversLastInsertedValue() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrieveTeamImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    // MARK: Player
//    func test_retrievePlayerImageData_deliversNotFoundWhenEmpty() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrievePlayerImageDataDeliversNotFoundOnEmptyCache(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    func test_retrievePlayerImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrievePlayerImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    func test_retrievePlayerImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrievePlayerImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    func test_retrievePlayerImageData_deliversLastInsertedValue() async throws {
//        try await makeSUT { sut, imageDataURL in
//            await self.assertThatRetrievePlayerImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
//        }
//    }
//    
//    // MARK: - Helpers
//    
//    private func makeSUT(_ test: @escaping (CoreDataLigasEcStore, URL) async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async throws {
//        let storeURL = URL(fileURLWithPath: "/dev/null")
//        let sut = try CoreDataLigasEcStore(storeURL: storeURL)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        
//        try await withCheckedThrowingContinuation { continuation in
//            sut.context.perform {
//                Task {
//                    do {
//                        let imageDataURL = URL(string: "http://league-url.com")!
//                        
//                        await insertLeague(with: imageDataURL, into: sut, file: file, line: line)
//                        await insertTeam(with: imageDataURL, into: sut, file: file, line: line)
//                        await insertPlayer(with: imageDataURL, into: sut, file: file, line: line)
//                        try await test(sut, imageDataURL)
//                        continuation.resume()
//                    } catch {
//                        continuation.resume(throwing: error)
//                    }
//                }
//            }
//        }
//    }
//    
//}
//
//private func insertLeague(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) async {
//    do {
//        let league = LocalLeague(id: "leagueId", name: "LigaPro Serie A", logoURL: url)
//        try await sut.insert([league], timestamp: Date())
//    } catch {
//        XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
//    }
//}
//
//private func insertTeam(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) async {
//    do {
//        let team = LocalTeam(id: "teamId", name: "Barcelona SC", logoURL: url)
//        try await sut.insert([team], with: "leagueId")
//    } catch {
//        XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
//    }
//}
//
//private func insertPlayer(with url: URL, into sut: CoreDataLigasEcStore, file: StaticString = #filePath, line: UInt = #line) async {
//    do {
//        let player = LocalPlayer(id: "playerId", name: "Alexander Dominguez", number: 1, position: "Portero", photoURL: anyURL())
//        try await sut.insert([player], with: "teamId")
//    } catch {
//        XCTFail("Failed to insert league with URL \(url) - error: \(error)", file: file, line: line)
//    }
//}
