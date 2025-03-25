//
//  LeagueStoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

protocol LeagueStoreSpecs {
    func test_insert_deliversNoErrorOnEmptyCache() throws
    func test_insert_deliversNoErrorOnNonEmptyCache() throws
    func test_insert_doNotSaveOnNonEmptyCache() throws
    
    func test_delete_deliversNoErrorOnEmptyCache() throws
    func test_delete_hasNoSideEffectsOnEmptyCache() throws
    func test_delete_deliversNoErrorOnNonEmptyCache() throws
    func test_delete_emptiesPreviouslyInsertedCache() throws
}
