//
//  PlayerMapperTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 7/3/25.
//

import XCTest
import LigasEcApp

final class PlayerMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = "".makeJSON()
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try PlayerMapper.map(json, from: HTTPURLResponse(statusCode: code), with: .flashLive)
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)

        // Assert
        XCTAssertThrowsError(
            // Act
            try PlayerMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200), with: .flashLive)
        )
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems_FlashLive() throws {
        // Arrange
        let item = makePlayerItemFlashLive()
        let jsonString = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"GOALKEEPER\",\"PLAYER_JERSEY_NUMBER\":1,\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try PlayerMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200), with: .flashLive)

        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItemsWithoutNumber_FlashLive() throws {
        // Arrange
        let item = makePlayerItemFlashLiveWithoutNumber()
        let jsonString = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"GOALKEEPER\",\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try PlayerMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200), with: .flashLive)

        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItemsWithoutNumberAndWithOtherPositions_FlashLive() throws {
        // Arrange
        let item3 = makePlayerItemFlashLiveWithoutNumberAndDefender()
        let jsonString3 = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"DEFENDER\",\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        
        let item4 = makePlayerItemFlashLiveWithoutNumberAndMidfielder()
        let jsonString4 = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"MIDFIELDER\",\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        
        let item5 = makePlayerItemFlashLiveWithoutNumberAndForward()
        let jsonString5 = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"FORWARD\",\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        
        let item6 = makePlayerItemFlashLiveWithoutNumberAndCoach()
        let jsonString6 = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"COACH\",\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        
        let json3 = jsonString3.makeJSON()
        let json4 = jsonString4.makeJSON()
        let json5 = jsonString5.makeJSON()
        let json6 = jsonString6.makeJSON()

        // Act
        let result3 = try PlayerMapper.map(json3,
                                          from: HTTPURLResponse(statusCode: 200), with: .flashLive)
        let result4 = try PlayerMapper.map(json4,
                                          from: HTTPURLResponse(statusCode: 200), with: .flashLive)
        let result5 = try PlayerMapper.map(json5,
                                          from: HTTPURLResponse(statusCode: 200), with: .flashLive)
        let result6 = try PlayerMapper.map(json6,
                                          from: HTTPURLResponse(statusCode: 200), with: .flashLive)

        // Assert
        XCTAssertEqual(result3, [item3])
        XCTAssertEqual(result4, [item4])
        XCTAssertEqual(result5, [item5])
        XCTAssertEqual(result6, [item6])

    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems_TransferMarket() throws {
        // Arrange
        let item = makePlayerItemTransferMarket()
        let jsonString = """
        {\"squad\":[{\"height\":\"1,75\",\"foot\":\"Izquierdo\",\"injury\":null,\"suspension\":null,\"joined\":1740265200,\"contractUntil\":1767135600,\"captain\":true,\"lastClub\":null,\"isLoan\":null,\"wasLoan\":null,\"id\":\"106495\",\"name\":\"Jonathan de la Cruz\",\"image\":\"https://img.a.transfermarkt.technology/portrait/medium/106495-1733949391.JPG?lm=1\",\"imageLarge\":null,\"imageSource\":\"IDV Prensa\",\"shirtNumber\":\"8\",\"age\":32,\"dateOfBirth\":711410400,\"heroImage\":null,\"isGoalkeeper\":false,\"positions\":{\"first\":{\"id\":\"10\",\"name\":\"Mediocentro ofensivo\",\"shortName\":\"MCO\",\"group\":\"Centrocampista\"},\"second\":{\"id\":\"6\",\"name\":\"Pivote\",\"shortName\":\"PIV\",\"group\":\"Centrocampista\"},\"third\":{\"id\":\"11\",\"name\":\"Extremo izquierdo\",\"shortName\":\"EI\",\"group\":\"Delantero\"}},\"nationalities\":[{\"id\":44,\"name\":\"Ecuador\",\"image\":\"https://tmssl.akamaized.net//images/flagge/small/44.png?lm=1520611569\"}],\"marketValue\":{\"value\":25000,\"currency\":\"€\",\"progression\":null}}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try PlayerMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200), with: .transferMarket)

        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItemsWithoutNumber_TransferMarket() throws {
        // Arrange
        let item = makePlayerItemTransferMarketWithoutNumber()
        let jsonString = """
        {\"squad\":[{\"height\":\"1,75\",\"foot\":\"Izquierdo\",\"injury\":null,\"suspension\":null,\"joined\":1740265200,\"contractUntil\":1767135600,\"captain\":true,\"lastClub\":null,\"isLoan\":null,\"wasLoan\":null,\"id\":\"106495\",\"name\":\"Jonathan de la Cruz\",\"image\":\"https://img.a.transfermarkt.technology/portrait/medium/106495-1733949391.JPG?lm=1\",\"imageLarge\":null,\"imageSource\":\"IDV Prensa\",\"shirtNumber\":\"ocho\",\"age\":32,\"dateOfBirth\":711410400,\"heroImage\":null,\"isGoalkeeper\":false,\"positions\":{\"first\":{\"id\":\"10\",\"name\":\"Mediocentro ofensivo\",\"shortName\":\"MCO\",\"group\":\"Centrocampista\"},\"second\":{\"id\":\"6\",\"name\":\"Pivote\",\"shortName\":\"PIV\",\"group\":\"Centrocampista\"},\"third\":{\"id\":\"11\",\"name\":\"Extremo izquierdo\",\"shortName\":\"EI\",\"group\":\"Delantero\"}},\"nationalities\":[{\"id\":44,\"name\":\"Ecuador\",\"image\":\"https://tmssl.akamaized.net//images/flagge/small/44.png?lm=1520611569\"}],\"marketValue\":{\"value\":25000,\"currency\":\"€\",\"progression\":null}}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try PlayerMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200), with: .transferMarket)

        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItemsWithoutPosition_TransferMarket() throws {
        // Arrange
        let item = makePlayerItemTransferMarketWithoutNumberAndWithNationality()
        let jsonString = """
        {\"squad\":[{\"height\":\"1,75\",\"foot\":\"Izquierdo\",\"injury\":null,\"suspension\":null,\"joined\":1740265200,\"contractUntil\":1767135600,\"captain\":true,\"lastClub\":null,\"isLoan\":null,\"wasLoan\":null,\"id\":\"106495\",\"name\":\"Jonathan de la Cruz\",\"image\":\"https://img.a.transfermarkt.technology/portrait/medium/106495-1733949391.JPG?lm=1\",\"imageLarge\":null,\"imageSource\":\"IDV Prensa\",\"age\":32,\"dateOfBirth\":711410400,\"heroImage\":null,\"isGoalkeeper\":false,\"nationalities\":[{\"id\":44,\"name\":\"Ecuador\",\"image\":\"https://tmssl.akamaized.net//images/flagge/small/44.png?lm=1520611569\"}],\"marketValue\":{\"value\":25000,\"currency\":\"€\",\"progression\":null}}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try PlayerMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200), with: .transferMarket)

        // Assert
        XCTAssertEqual(result, [item])
    }
    

    // MARK: - Helpers

    private func makePlayerItemFlashLive() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: 1,
               position: "Portero",
               flagId: 205,
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
               dataSource: .flashLive)
    }
    
    private func makePlayerItemFlashLiveWithoutNumber() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: nil,
               position: "Portero",
               flagId: 205,
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
               dataSource: .flashLive)
    }
    
    private func makePlayerItemFlashLiveWithoutNumberAndDefender() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: nil,
               position: "Defensa",
               flagId: 205,
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
               dataSource: .flashLive)
    }
    
    private func makePlayerItemFlashLiveWithoutNumberAndMidfielder() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: nil,
               position: "Centrocampista",
               flagId: 205,
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
               dataSource: .flashLive)
    }
    
    private func makePlayerItemFlashLiveWithoutNumberAndForward() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: nil,
               position: "Delantero",
               flagId: 205,
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
               dataSource: .flashLive)
    }
    
    private func makePlayerItemFlashLiveWithoutNumberAndCoach() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: nil,
               position: "Entrenador",
               flagId: 205,
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
               dataSource: .flashLive)
    }
    
    private func makePlayerItemTransferMarket() -> Player {
        Player(id: "106495",
               name: "Jonathan de la Cruz",
               number: 8,
               position: "Centrocampista",
               nationality: "Ecuador",
               photoURL: URL(string: "https://img.a.transfermarkt.technology/portrait/medium/106495-1733949391.JPG?lm=1")!,
               dataSource: .transferMarket)
    }
    
    private func makePlayerItemTransferMarketWithoutNumber() -> Player {
        Player(id: "106495",
               name: "Jonathan de la Cruz",
               number: nil,
               position: "Centrocampista",
               nationality: "Ecuador",
               photoURL: URL(string: "https://img.a.transfermarkt.technology/portrait/medium/106495-1733949391.JPG?lm=1")!,
               dataSource: .transferMarket)
    }
    
    private func makePlayerItemTransferMarketWithoutNumberAndWithNationality() -> Player {
        Player(id: "106495",
               name: "Jonathan de la Cruz",
               number: nil,
               position: "",
               nationality: "Ecuador",
               photoURL: URL(string: "https://img.a.transfermarkt.technology/portrait/medium/106495-1733949391.JPG?lm=1")!,
               dataSource: .transferMarket)
    }

}
