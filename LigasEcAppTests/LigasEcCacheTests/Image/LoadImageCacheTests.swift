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
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        // Arrange
        let (sut, store) = makeSUT()

        // Act
        _ = try? sut.loadImageData(from: anyURL(), on: mockLeagueTable())

        // Assert
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: anyURL())])
    }

    func test_loadImageDataFromURL_deliversStoredDataOnFoundData() {
        // Arrange
        let (sut, store) = makeSUT()
        let foundData = anyData()

        // Act & Assert
        expect(sut, on: mockLeagueTable(), toCompleteWith: .success(foundData), when: {
            store.completeRetrieval(with: foundData)
        })
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        expect(sut, on: mockLeagueTable(), toCompleteWith: notFound(), when: {
            store.completeRetrieval(with: .none)
        })
    }
    
    func test_loadImageDataFromURL_deliversFailedErrorOnRetrieveError() {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        expect(sut, on: mockLeagueTable(), toCompleteWith: failed(), when: {
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
    
    private func expect(_ sut: LocalImageLoader, on table: Table, toCompleteWith expectedResult: Result<Data, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        // Act
        action()
        
        let receivedResult = Result { try sut.loadImageData(from: anyURL(), on: table) }
        
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
