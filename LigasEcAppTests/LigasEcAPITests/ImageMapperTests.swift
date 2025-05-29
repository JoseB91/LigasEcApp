//
//  ImageMapperTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 12/3/25.
//

import XCTest
import LigasEcApp

class ImageMapperTests: XCTestCase {

    func test_map_deliversNonEmptyDataOn200HTTPResponse() throws {
        // Arrange
        let nonEmptyData = Data("non-empty data".utf8)

        // Act
        let result = try ImageMapper.map(nonEmptyData,
                                         from: HTTPURLResponse(statusCode: 200))

        // Assert
        XCTAssertEqual(result, nonEmptyData)
    }
    
    func test_map_throwsUnsuccessfullyResponseErrorOn200HTTPResponseWithEmptyData() {
        // Arrange
        let emptyData = Data()

        // Act & Assert
        XCTAssertThrowsError(
            try ImageMapper.map(emptyData, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_throwsUnsuccessfullyResponseErrorOnNon200HTTPResponse() throws {
        // Arrange
        let samples = [199, 201, 300, 400, 500]

        // Act & Assert
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageMapper.map(anyData(),
                                    from: HTTPURLResponse(statusCode: code))
            )
        }
    }
}
