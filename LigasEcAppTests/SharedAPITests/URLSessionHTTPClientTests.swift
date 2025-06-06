//
//  URLSessionHTTPClientTests.swift
//  SharedAPITests
//
//  Created by José Briones on 20/2/25.
//

import XCTest
import LigasEcApp

class URLSessionHTTPClientTests: XCTestCase {
        
    func test_getFromURL_failsWithError_havingError() async throws {
        // Arrange
        let url = anyURL()
        let (sut, _) = makeSUT(result: .failure(anyNSError()))
        
        do {
            //Act
            _ = try await sut.get(from: url, with: "host")
            //Assert
            XCTFail("Expected error, but the call succeeded.")
        } catch let error as URLError {
            //Assert
            XCTAssertEqual(error.code, .cannotLoadFromNetwork)
        } catch {
            //Assert
            XCTFail("Expected URLError, but received: \(error)")
        }
    }
    
    func test_getFromURL_failsWithBadServerResponse_havingNonHTTPURLResponse() async throws {
        // Arrange
        let url = anyURL()
        let (sut, _) = makeSUT(result: .success((anyData(), nonHTTPURLResponse())))
        
        do {
            //Act
            _ = try await sut.get(from: url, with: "host")
            //Assert
            XCTFail("Expected error, but the call succeeded.")
        } catch let error as URLError {
            //Assert
            XCTAssertEqual(error.code, .badServerResponse)
        } catch {
            //Assert
            XCTFail("Expected URLError, but received: \(error)")
        }
    }

    func test_getFromURL_succeedsWithData_havingDataAndAnyHTTPURLResponse() async throws {
        // Arrange
        let url = anyURL()
        let mockedData = anyData()
        let mockedResponse = anyHTTPURLResponse()
        let (sut, _) = makeSUT(result: .success((mockedData, mockedResponse)))

        // Act
        let (expectedData, expectedResponse) = try await sut.get(from: url, with: "host")
        
        // Assert
        XCTAssertEqual(expectedData, mockedData)
        XCTAssertEqual(expectedResponse.url, url)
        XCTAssertEqual(expectedResponse.statusCode, mockedResponse.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyData_havingEmptyDataAndAnyHTTPURLResponse() async throws {
        // Arrange
        let url = anyURL()
        let emptyData = Data()
        let mockedResponse = anyHTTPURLResponse()
        let (sut, _) = makeSUT(result: .success((emptyData, mockedResponse)))
        
        // Act
        let (expectedData, expectedResponse) = try await sut.get(from: url, with: "host")
        
        // Assert
        XCTAssertEqual(expectedData, emptyData)
        XCTAssertEqual(expectedResponse.url, url)
        XCTAssertEqual(expectedResponse.statusCode, mockedResponse.statusCode)
    }
    
    func test_getFromURL_failsWithError_havingError_withoutHost() async throws {
        // Arrange
        let url = anyURL()
        let (sut, _) = makeSUT(result: .failure(anyNSError()))
        
        do {
            //Act
            _ = try await sut.get(from: url)
            //Assert
            XCTFail("Expected error, but the call succeeded.")
        } catch let error as URLError {
            //Assert
            XCTAssertEqual(error.code, .cannotLoadFromNetwork)
        } catch {
            //Assert
            XCTFail("Expected URLError, but received: \(error)")
        }
    }
    
    func test_getFromURL_failsWithBadServerResponse_havingNonHTTPURLResponse_withoutHost() async throws {
        // Arrange
        let url = anyURL()
        let (sut, _) = makeSUT(result: .success((anyData(), nonHTTPURLResponse())))
        
        do {
            //Act
            _ = try await sut.get(from: url)
            //Assert
            XCTFail("Expected error, but the call succeeded.")
        } catch let error as URLError {
            //Assert
            XCTAssertEqual(error.code, .badServerResponse)
        } catch {
            //Assert
            XCTFail("Expected URLError, but received: \(error)")
        }
    }

    func test_getFromURL_succeedsWithData_havingDataAndAnyHTTPURLResponse_withoutHost() async throws {
        // Arrange
        let url = anyURL()
        let mockedData = anyData()
        let mockedResponse = anyHTTPURLResponse()
        let (sut, _) = makeSUT(result: .success((mockedData, mockedResponse)))

        // Act
        let (expectedData, expectedResponse) = try await sut.get(from: url)
        
        // Assert
        XCTAssertEqual(expectedData, mockedData)
        XCTAssertEqual(expectedResponse.url, url)
        XCTAssertEqual(expectedResponse.statusCode, mockedResponse.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyData_havingEmptyDataAndAnyHTTPURLResponse_withoutHost() async throws {
        // Arrange
        let url = anyURL()
        let emptyData = Data()
        let mockedResponse = anyHTTPURLResponse()
        let (sut, _) = makeSUT(result: .success((emptyData, mockedResponse)))
        
        // Act
        let (expectedData, expectedResponse) = try await sut.get(from: url)
        
        // Assert
        XCTAssertEqual(expectedData, emptyData)
        XCTAssertEqual(expectedResponse.url, url)
        XCTAssertEqual(expectedResponse.statusCode, mockedResponse.statusCode)
    }
        
    // MARK: - Helpers
    
    private func makeSUT(
        result: Result<(Data, URLResponse), Error>,
        file: StaticString = #file, line: UInt = #line
    ) -> (sut: URLSessionHTTPClient, sessionSpy: URLSessionSpy) {
        let sessionSpy = URLSessionSpy(result: result)
        let sut = URLSessionHTTPClient(session: sessionSpy, apiKey: "")
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, sessionSpy)
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
