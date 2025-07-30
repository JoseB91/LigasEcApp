//
//  URLSessionHTTPClientTests.swift
//  SharedAPITests
//
//  Created by José Briones on 20/2/25.
//

import Testing
import Foundation
import LigasEcApp

//TODO: Check tests
@Suite("URLSessionHTTPClient Tests")
struct URLSessionHTTPClientTests : ~Copyable{
    
    init() {
        URLProtocolStub.startInterceptingRequests()
    }
    
    deinit {
        URLProtocolStub.stopInterceptingRequests()
    }
    
    @Test("GET request performs correctly with URL")
    func getFromURL_performsGETRequestWithURL() async throws {
        let sut = makeSUT()
        let url = anyURL()
        
        URLProtocolStub.request = nil
        
        _ = try? await sut.get(from: url, with: "host")

        #expect(URLProtocolStub.request?.url == url)
        #expect(URLProtocolStub.request?.httpMethod == "GET")
    }
        
    @Test("GET request throws error on request failure")
    func getFromURL_throwsErrorOnRequestFailure() async throws {
        let sut = makeSUT()
        
        URLProtocolStub.error = URLError(.notConnectedToInternet)
        
        await #expect(throws: URLError.self) {
            _ = try await sut.get(from: anyURL(), with: "host")
        }
    }

    @Test("GET request throws error on non-HTTP response")
    func getFromURL_throwsErrorOnNonHTTPResponse() async {
        let sut = makeSUT()

        URLProtocolStub.error = URLError(.badServerResponse)
        
        await #expect(throws: URLError.self) {
            _ = try await sut.get(from: anyURL(), with: "host")
        }
    }
    
    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) -> HTTPClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        
        let session = URLSession(configuration: config)
        let sut = URLSessionHTTPClient(session: session, apiKey: "apiKey")
        
        return sut
    }
    
    // MARK: - Helpers
        
    func anyData() -> Data {
        return Data("any data".utf8)
    }
}
