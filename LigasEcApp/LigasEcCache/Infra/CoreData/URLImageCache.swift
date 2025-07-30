//
//  URLImageCache.swift
//  LigasEcApp
//
//  Created by José Briones on 16/4/25.
//

import Foundation

class URLImageCache {
    static let shared = URLImageCache()
    
    // NSCache is thread-safe and automatically manages memory pressure
    private let cache = NSCache<NSURL, NSData>()
    
    private init() {
        cache.countLimit = 100 // Maximum number of items
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB limit
    }
    
    func setImageData(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    func getImageData(for url: URL) -> Data? {
        return cache.object(forKey: url as NSURL) as Data?
    }
}
