//
//  SaveImageCacheTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 12/3/25.
//

import XCTest
@testable import LigasEcApp

class SaveImageCacheTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()

        // Assert
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        // Arrange
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()

        // Act
        try? sut.save(data, for: url)
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataFromURL_failsOnStoreInsertionError() {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        expect(sut, toCompleteWith: failed(), when: {
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalImageLoader, store: ImageStoreSpy) {
        let store = ImageStoreSpy()
        let sut = LocalImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> Result<Void, Error> {
        return .failure(LocalImageLoader.SaveError.failed)
    }

    private func expect(_ sut: LocalImageLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {

        // Act
        action()
        
        let receivedResult = Result { try sut.save(anyData(), for: anyURL()) }

                switch (receivedResult, expectedResult) {
                case (.success, .success):
                    break

                case (.failure(let receivedError as LocalImageLoader.SaveError),
                      .failure(let expectedError as LocalImageLoader.SaveError)):
                    // Assert
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                    
                default:
                    // Assert
                    XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
                }
    }
}
