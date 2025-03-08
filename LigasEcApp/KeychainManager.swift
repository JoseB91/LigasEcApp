//
//  KeychainManager.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import Foundation
import Security

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unhandledError(status: OSStatus)
}

class KeychainManager { //TODO: Add tests 
    
    static let apiKeyIdentifier = "com.ligasec.apikey"
    
    static func saveAPIKey(_ apiKey: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: apiKeyIdentifier,
            kSecValueData: apiKey.data(using: .utf8)!
        ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    static func retrieveAPIKey() throws -> String {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: apiKeyIdentifier,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String: Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let data = item as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        
        return apiKey
    }
    
    static func deleteAPIKey() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: apiKeyIdentifier
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
