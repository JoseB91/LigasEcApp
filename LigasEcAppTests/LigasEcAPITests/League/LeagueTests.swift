//
//  LeagueTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 8/3/25.
//

import XCTest
import LigasEcApp

final class LeagueTests: XCTestCase {
    
    func test_leagueInit() {
        let league = League(id: "IaFDigtm",
                            name: "LigaPro Serie A",
                            logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                            dataSource: .FlashLive)
        
        XCTAssertEqual(league.id, "IaFDigtm")
        XCTAssertEqual(league.name, "LigaPro Serie A")
        XCTAssertEqual(league.logoURL, URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!)
        XCTAssertEqual(league.dataSource, .FlashLive)

    }
}
