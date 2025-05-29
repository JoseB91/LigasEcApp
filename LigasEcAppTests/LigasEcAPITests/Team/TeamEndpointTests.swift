//
//  TeamEndpointTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 8/3/25.
//

import XCTest
import LigasEcApp

class TeamEndpointTests: XCTestCase {

    func test_team_endpointFlashLiveURL() {
        // Arrange
        let baseURL = URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!
        
        // Act
        let received = TeamEndpoint.getFlashLive(seasonId: "OEW8zvIT",
                                        standingType: "home",
                                        locale: "es_MX",
                                        tournamentStageId: "OO37de6i").url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "flashlive-sports.p.rapidapi.com", "host")
        XCTAssertEqual(received.path, "/v1/tournaments/standings", "path")
        XCTAssertEqual(received.query?.contains("tournament_season_id=OEW8zvIT"), true)
        XCTAssertEqual(received.query?.contains("standing_type=home"), true)
        XCTAssertEqual(received.query?.contains("locale=es_MX"), true)
        XCTAssertEqual(received.query?.contains("tournament_stage_id=OO37de6i"), true)
    }
    
    func test_team_endpointTransferMarketURL() {
        // Arrange
        let baseURL = URL(string: "https://transfermarket.p.rapidapi.com/")!
        
        // Act
        let received = TeamEndpoint.getTransferMarket(id: "EC2L",
                                                      domain: "es").url(baseURL: baseURL)
                                       
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "transfermarket.p.rapidapi.com", "host")
        XCTAssertEqual(received.path, "/clubs/list-by-competition", "path")
        XCTAssertEqual(received.query?.contains("id=EC2L"), true)
        XCTAssertEqual(received.query?.contains("domain=es"), true)
    }
}
