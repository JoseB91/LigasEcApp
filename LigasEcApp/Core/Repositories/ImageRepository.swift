//
//  ImageRepository.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

protocol ImageRepository {
    func loadImage() async throws -> Data
}

final class ImageRepositoryImpl: ImageRepository {
    private let url: URL
    private let table: Table
    private let httpClient: URLSessionHTTPClient
    private let appLocalLoader: AppLocalLoader

    init(url: URL, table: Table, httpClient: URLSessionHTTPClient, appLocalLoader: AppLocalLoader) {
        self.url = url
        self.table = table
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
    }
    
    func loadImage() async throws -> Data {
        do {
            return try await appLocalLoader.localImageLoader.loadImageData(from: url, on: table)
        } catch {
            let (data, response) = try await httpClient.get(from: url)
            let imageData = try ImageMapper.map(data, from: response)
            
            try? await appLocalLoader.localImageLoader.save(imageData, for: url, on: table)
            
            return imageData
        }
    }
}
