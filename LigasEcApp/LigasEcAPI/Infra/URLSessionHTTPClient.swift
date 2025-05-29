//
//  URLSessionHTTPClient.swift
//  SharedAPI
//
//  Created by José Briones on 20/2/25.
//

import Foundation

public protocol URLSessionProtocol {
    func data(request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    public func data(request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: delegate)
    }
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSessionProtocol
    private let apiKey: String
    
    public init(session: URLSessionProtocol, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }
            
    public func get(from url: URL, with host: String) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 8.0)
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(host, forHTTPHeaderField: "x-rapidapi-host")
        
        guard let (data, response) = try? await session.data(request: request, delegate: nil) else {
            throw URLError(.cannotLoadFromNetwork)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpResponse)
    }
    
    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        
        guard let (data, response) = try? await session.data(request: request, delegate: nil) else {
            throw URLError(.cannotLoadFromNetwork)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpResponse)
    }
}
