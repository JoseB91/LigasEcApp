//
//  URLSessionHTTPClient.swift
//  SharedAPI
//
//  Created by José Briones on 20/2/25.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let apiKey: String
    
    public init(session: URLSession, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }
    
    public func get(from url: URL, with host: String) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 8.0)
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(host, forHTTPHeaderField: "x-rapidapi-host")
        
        return try await performRequest(request)
    }
    
    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        return try await performRequest(request)
    }
    
    // MARK: - Private Methods
    
    private func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            return (data, httpResponse)
        } catch let urlError as URLError {
            throw urlError
        } catch {
            throw URLError(.unknown, userInfo: [NSUnderlyingErrorKey: error])
        }
    }
}
