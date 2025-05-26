//
//  ImageStoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 12/3/25.
//

protocol ImageStoreSpecs {
    func test_retrieveLeagueImageData_deliversNotFoundWhenEmpty() async throws
    func test_retrieveLeagueImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws
    func test_retrieveLeagueImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws
    func test_retrieveLeagueImageData_deliversLastInsertedValue() async throws
    
    func test_retrieveTeamImageData_deliversNotFoundWhenEmpty() async throws
    func test_retrieveTeamImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws
    func test_retrieveTeamImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws
    func test_retrieveTeamImageData_deliversLastInsertedValue() async throws
    
//    func test_retrievePlayerImageData_deliversNotFoundWhenEmpty() async throws
//    func test_retrievePlayerImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws
//    func test_retrievePlayerImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws
//    func test_retrievePlayerImageData_deliversLastInsertedValue() async throws

}
