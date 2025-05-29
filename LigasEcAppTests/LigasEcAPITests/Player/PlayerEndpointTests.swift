//
//  PlayerEndpointTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 8/3/25.
//

import XCTest
import LigasEcApp

class PlayerEndpointTests: XCTestCase {

    func test_player_endpointFlashLiveURL() {
        let baseURL = URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!

        let received = PlayerEndpoint.getFlashLive(sportId: 1,
                                          locale: "es_MX",
                                          teamId: "Wtn9Stg0").url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "flashlive-sports.p.rapidapi.com", "host")
        XCTAssertEqual(received.path, "/v1/teams/squad", "path")
        XCTAssertEqual(received.query?.contains("sport_id=1"), true)
        XCTAssertEqual(received.query?.contains("locale=es_MX"), true)
        XCTAssertEqual(received.query?.contains("team_id=Wtn9Stg0"), true)
    }
    
    func test_player_endpointTransferMarketURL() {
        // Arrange
        let baseURL = URL(string: "https://transfermarket.p.rapidapi.com/")!
        
        // Act
        let received = PlayerEndpoint.getTransferMarket(id: "41301",
                                                        domain: "es").url(baseURL: baseURL)
                                       
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "transfermarket.p.rapidapi.com", "host")
        XCTAssertEqual(received.path, "/clubs/get-squad", "path")
        XCTAssertEqual(received.query?.contains("id=41301"), true)
        XCTAssertEqual(received.query?.contains("domain=es"), true)
    }
}
