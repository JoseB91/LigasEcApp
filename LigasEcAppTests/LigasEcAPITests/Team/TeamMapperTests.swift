//
//  TeamMapperTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 7/3/25.
//

import XCTest
import LigasEcApp

final class TeamMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = "".makeJSON()
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try TeamMapper.map(json, from: HTTPURLResponse(statusCode: code), with: .FlashLive)
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)

        // Assert
        XCTAssertThrowsError(
            // Act
            try TeamMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200), with: .FlashLive)
        )
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems_FlashLive() throws {
        // Arrange
        let item = makeTeamItemFlashLive()
        let jsonString = """
        {\"DATA\":[{\"GROUP_ID\":1,\"GROUP\":\"Main\",\"ROWS\":[{\"RANKING\":1,\"TEAM_QUALIFICATION\":\"q1\",\"TUC\":\"004682\",\"TEAM_NAME\":\"Barcelona SC\",\"TEAM_ID\":\"pCMG6CNp\",\"MATCHES_PLAYED\":3,\"WINS\":3,\"GOALS\":\"8:3\",\"POINTS\":9.0,\"DYNAMIC_COLUMNS_DATA\":[\"3\",\"8:3\",\"9\"],\"PARTICIPANT_ID\":715,\"DYNAMIC_COLUMNS_DATA_LIVE\":null,\"TEAM_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png\"}]}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try TeamMapper.map(json, from: HTTPURLResponse(statusCode: 200), with: .FlashLive)

        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems_TransferMarket() throws {
        // Arrange
        let item = makeTeamItemTransferMarket()
        let jsonString = """
        {\"clubs\":[{\"id\":\"41301\",\"name\":\"Cumbayá FC\",\"image\":\"https://tmssl.akamaized.net//images/wappen/medium/41301.png?lm=1677580396\"}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try TeamMapper.map(json, from: HTTPURLResponse(statusCode: 200), with: .TransferMarket)

        // Assert
        XCTAssertEqual(result, [item])
    }

    // MARK: - Helpers

    private func makeTeamItemFlashLive() -> Team {
        Team(id: "pCMG6CNp",
             name: "Barcelona SC",
             logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!,
             dataSource: .FlashLive)
    }
    
    private func makeTeamItemTransferMarket() -> Team {
        Team(id: "41301",
             name: "Cumbayá FC",
             logoURL: URL(string: "https://tmssl.akamaized.net//images/wappen/medium/41301.png?lm=1677580396")!,
             dataSource: .TransferMarket)
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension String {
    func makeJSON() -> Data {
        return self.data(using: .utf8)!
    }
}
