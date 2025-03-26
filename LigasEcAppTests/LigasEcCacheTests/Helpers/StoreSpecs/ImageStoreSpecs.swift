//
//  ImageStoreSpecs.swift
//  LigasEcAppTests
//
//  Created by José Briones on 12/3/25.
//

protocol ImageStoreSpecs {
    func test_retrieveLeagueImageData_deliversNotFoundWhenEmpty() throws
    func test_retrieveLeagueImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws
    func test_retrieveLeagueImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws
    func test_retrieveLeagueImageData_deliversLastInsertedValue() throws
    
    func test_retrieveTeamImageData_deliversNotFoundWhenEmpty() throws
    func test_retrieveTeamImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws
    func test_retrieveTeamImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws
    func test_retrieveTeamImageData_deliversLastInsertedValue() throws

}
