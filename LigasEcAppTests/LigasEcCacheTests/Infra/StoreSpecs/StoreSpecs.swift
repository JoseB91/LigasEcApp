//
//  LeagueStoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

protocol LeagueStoreSpecs {
    func test_insert_deliversNoErrorOnEmptyCache() async throws
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws
    func test_insert_doNotSaveOnNonEmptyCache() async throws
    
    func test_delete_deliversNoErrorOnEmptyCache() async throws
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws
    func test_delete_emptiesPreviouslyInsertedCache() async throws
}

protocol TeamStoreSpecs {
    func test_retrieve_deliversNoErrorOnEmptyCache() async throws
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() async throws
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async throws

    func test_insert_deliversNoErrorOnEmptyCache() async throws
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws
    func test_insert_overridesPreviouslyInsertedCacheValues() async throws
}

protocol PlayerStoreSpecs {
    func test_retrieve_deliversNoErrorOnEmptyCache() async throws
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() async throws
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async throws

    func test_insert_deliversNoErrorOnEmptyCache() async throws
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws
    func test_insert_overridesPreviouslyInsertedCacheValues() async throws
}
