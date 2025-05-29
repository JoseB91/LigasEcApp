//
//  HTTPClient.swift
//  SharedAPI
//
//  Created by José Briones on 20/2/25.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, with host: String) async throws -> (Data, HTTPURLResponse)
}
