//
//  URLSessionSpy.swift
//  SharedAPITests
//
//  Created by José Briones on 20/2/25.
//

import Foundation
import LigasEcApp

class URLSessionSpy: URLSessionProtocol {
    private(set) var requests = [URLRequest]()

    let result: Result<(Data, URLResponse), Error>

    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }

    func data(request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        self.requests.append(request)
        return try result.get()
    }
}
