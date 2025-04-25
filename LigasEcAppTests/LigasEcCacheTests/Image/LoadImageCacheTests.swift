//
//  LoadImageCacheTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 12/3/25.
//

import XCTest
import LigasEcAPI
@testable import LigasEcApp

class LoadImageCacheTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()

        // Assert
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() async {
        // Arrange
        let (sut, store) = makeSUT()

        // Act
        _ = try? await sut.loadImageData(from: anyURL(), on: mockLeagueTable())

        // Assert
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: anyURL())])
    }

    func test_loadImageDataFromURL_deliversStoredDataOnFoundData() async {
        // Arrange
        let (sut, store) = makeSUT()
        let foundData = anyData()

        // Act & Assert
        await expect(sut, on: mockLeagueTable(), toCompleteWith: .success(foundData), when: {
            store.completeRetrieval(with: foundData)
        })
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() async {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, on: mockLeagueTable(), toCompleteWith: notFound(), when: {
            store.completeRetrieval(with: .none)
        })
    }
    
    func test_loadImageDataFromURL_deliversFailedErrorOnRetrieveError() async {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, on: mockLeagueTable(), toCompleteWith: failed(), when: {
            let retrievalError = anyNSError()
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalImageLoader, store: ImageStoreSpy) {
        let store = ImageStoreSpy()
        let sut = LocalImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> Result<Data, Error>  {
        return .failure(LocalImageLoader.LoadError.failed)
    }
    
    private func notFound() -> Result<Data, Error>  {
        return .failure(LocalImageLoader.LoadError.notFound)
    }
    
    private func expect(_ sut: LocalImageLoader, on table: Table, toCompleteWith expectedResult: Result<Data, Error>, when action: () async -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        
        // Act
        await action()
        
        let receivedResult: Result<Data, Error>
        
        do {
           let receivedImageData = try await sut.loadImageData(from: anyURL(), on: table)
            receivedResult = .success(receivedImageData)
        } catch {
            receivedResult = .failure(error)
        }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedData), .success(expectedData)):
            // Assert
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            
        case (.failure(let receivedError as LocalImageLoader.LoadError),
              .failure(let expectedError as LocalImageLoader.LoadError)):
            // Assert
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            // Assert
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
