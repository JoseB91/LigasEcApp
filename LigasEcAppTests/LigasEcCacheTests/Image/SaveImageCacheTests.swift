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

    func test_saveImageDataForURL_requestsImageDataInsertionForURL() async {
        // Arrange
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()

        // Act
        try? await sut.save(data, for: url, on: mockLeagueTable())
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() async {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, on: mockLeagueTable(), toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_saveImageDataFromURL_failsOnStoreInsertionError() async {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, on: mockLeagueTable(), toCompleteWith: failed(), when: {
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
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

    private func expect(_ sut: LocalImageLoader, on table: Table, toCompleteWith expectedResult: Result<Void, Error>, when action: () async -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        
        // Act
        await action()
        
        let receivedResult : Result<Void, Error>
        
        do {
            try await sut.save(anyData(), for: anyURL(), on: table)
            receivedResult = .success(())
        } catch {
            receivedResult = .failure(error)
        }
        
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
