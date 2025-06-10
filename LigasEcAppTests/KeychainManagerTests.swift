//
//  KeychainManagerTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 21/5/25.
//

import XCTest
import Security
@testable import LigasEcApp

class KeychainManagerTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        if ProcessInfo.processInfo.environment["CI"] == "TRUE" {
            return
        }
        
        cleanupKeychain()
    }
    
    override func tearDown() {
        cleanupKeychain()
        super.tearDown()
    }
    
    private func cleanupKeychain() {
        try? KeychainManager.deleteAPIKey()
    }
    
    // MARK: - Save API Key Tests
    
    func test_saveAPIKey_Success() {
        // Arrange
        let testAPIKey = "test-api-key-12345"
        
        // Act & Assert
        XCTAssertNoThrow(try KeychainManager.saveAPIKey(testAPIKey))
    }
    
    func test_saveAPIKey_OverwritesExistingKey() throws {
        // Arrange
        let firstAPIKey = "first-api-key"
        let secondAPIKey = "second-api-key"
        
        // Act
        try KeychainManager.saveAPIKey(firstAPIKey)
        try KeychainManager.saveAPIKey(secondAPIKey)
        
        // Assert
        let retrievedKey = try KeychainManager.retrieveAPIKey()
        XCTAssertEqual(retrievedKey, secondAPIKey)
        XCTAssertNotEqual(retrievedKey, firstAPIKey)
    }
    
    func test_saveAPIKey_EmptyString() {
        // Arrange
        let emptyAPIKey = ""
        
        // Act & Assert
        XCTAssertNoThrow(try KeychainManager.saveAPIKey(emptyAPIKey))
    }
        
    // MARK: - Retrieve API Key Tests
    
    func test_retrieveAPIKey_Success() throws {
        // Arrange
        let testAPIKey = "test-retrieve-key-67890"
        try KeychainManager.saveAPIKey(testAPIKey)
        
        // Act
        let retrievedKey = try KeychainManager.retrieveAPIKey()
        
        // Assert
        XCTAssertEqual(retrievedKey, testAPIKey)
    }
    
    func test_retrieveAPIKey_ItemNotFound() {
        // Act & Assert
        XCTAssertThrowsError(try KeychainManager.retrieveAPIKey()) { error in
            XCTAssertTrue(error is KeychainError)
            if case KeychainError.itemNotFound = error {
                // Expected error type
            } else {
                XCTFail("Expected KeychainError.itemNotFound, got \(error)")
            }
        }
    }
    
    func test_retrieveAPIKey_AfterDelete() throws {
        // Arrange
        let testAPIKey = "test-key-to-delete"
        try KeychainManager.saveAPIKey(testAPIKey)
        try KeychainManager.deleteAPIKey()
        
        // Act & Assert
        XCTAssertThrowsError(try KeychainManager.retrieveAPIKey()) { error in
            if case KeychainError.itemNotFound = error {
                // Expected
            } else {
                XCTFail("Expected KeychainError.itemNotFound after deletion")
            }
        }
    }
    
    // MARK: - Delete API Key Tests
    
    func test_deleteAPIKey_Success() throws {
        // Arrange
        let testAPIKey = "test-key-for-deletion"
        try KeychainManager.saveAPIKey(testAPIKey)
        
        // Act & Assert
        XCTAssertNoThrow(try KeychainManager.retrieveAPIKey())
        
        // Act & Assert
        XCTAssertNoThrow(try KeychainManager.deleteAPIKey())
        
        // Assert
        XCTAssertThrowsError(try KeychainManager.retrieveAPIKey()) { error in
            if case KeychainError.itemNotFound = error {
                // Expected
            } else {
                XCTFail("Key should not exist after deletion")
            }
        }
    }
    
    func test_deleteAPIKey_ItemNotFound() {
        // Act & Assert
        XCTAssertNoThrow(try KeychainManager.deleteAPIKey())
    }
    
    func test_deleteAPIKey_MultipleDeletes() throws {
        // Arrange
        let testAPIKey = "test-key-multiple-deletes"
        try KeychainManager.saveAPIKey(testAPIKey)
        
        // Act
        XCTAssertNoThrow(try KeychainManager.deleteAPIKey())
        XCTAssertNoThrow(try KeychainManager.deleteAPIKey())
        XCTAssertNoThrow(try KeychainManager.deleteAPIKey())
        
        // Assert
        XCTAssertThrowsError(try KeychainManager.retrieveAPIKey())
    }
    
    // MARK: - Integration Tests
    
    func test_saveRetrieveDeleteCycle() throws {
        // Arrange
        let testAPIKey = "integration-test-key"
        
        // Act - Save
        try KeychainManager.saveAPIKey(testAPIKey)
        
        // Act - Retrieve
        let retrievedKey = try KeychainManager.retrieveAPIKey()
        
        // Assert
        XCTAssertEqual(retrievedKey, testAPIKey)
        
        // Act - Delete
        try KeychainManager.deleteAPIKey()
        
        // Assert
        XCTAssertThrowsError(try KeychainManager.retrieveAPIKey())
    }
        
    // MARK: - Edge Cases
        
    func test_apiKeyIdentifierConstant() {
        // Act
        let identifier = KeychainManager.apiKeyIdentifier
        
        // Assert
        XCTAssertEqual(identifier, "com.ligasec.apikey")
        XCTAssertFalse(identifier.isEmpty)
    }
    
    // MARK: - Performance Tests
    
    func test_saveAPIKeyPerformance() {
        // Arrange
        let testAPIKey = "performance-test-key"
        
        // Act & Assert
        measure {
            do {
                try KeychainManager.saveAPIKey(testAPIKey)
            } catch {
                XCTFail("Save should not fail: \(error)")
            }
        }
    }
    
    func test_retrieveAPIKeyPerformance() throws {
        // Arrange
        let testAPIKey = "performance-retrieve-key"
        try KeychainManager.saveAPIKey(testAPIKey)
        
        // Act & Assert
        measure {
            do {
                _ = try KeychainManager.retrieveAPIKey()
            } catch {
                XCTFail("Retrieve should not fail: \(error)")
            }
        }
    }
}
