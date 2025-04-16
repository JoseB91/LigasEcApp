//
//  URLImageCache.swift
//  LigasEcApp
//
//  Created by José Briones on 16/4/25.
//

import Foundation
import UIKit

// A simple singleton cache for image data
class URLImageCache {
    // Singleton instance
    static let shared = URLImageCache()
    
    // NSCache is thread-safe and automatically manages memory pressure
    private let cache = NSCache<NSURL, NSData>()
    
    private init() {
        // Configure cache limits if needed
        cache.countLimit = 100 // Maximum number of items
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB limit
    }
    
    // Store image data in cache
    func setImageData(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    // Retrieve image data from cache
    func getImageData(for url: URL) -> Data? {
        return cache.object(forKey: url as NSURL) as Data?
    }
    
    // Check if cache has data for URL
    func hasImageData(for url: URL) -> Bool {
        return cache.object(forKey: url as NSURL) != nil
    }
    
    // Remove data for a specific URL
    func removeImageData(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }
    
    // Clear all cached data
    func clearCache() {
        cache.removeAllObjects()
    }
}
