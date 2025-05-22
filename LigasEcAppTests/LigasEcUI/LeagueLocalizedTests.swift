//
//  LeagueLocalizedTests.swift
//  LigasEcAppTests
//
//  Created by José Briones on 24/2/25.
//

import XCTest
import SwiftUI
@testable import LigasEcApp

final class LeagueLocalizedTests: XCTestCase {
    
    func test_playerGoalkeeper_isLocalized() {
        let playerViewModel = PlayerViewModel(playerLoader: MockPlayerViewModel.mockPlayerLoader)
        XCTAssertEqual(playerViewModel.goalkeeper, localized("GOALKEEPER"))
    }
    
    func test_playerDefender_isLocalized() {
        let playerViewModel = PlayerViewModel(playerLoader: MockPlayerViewModel.mockPlayerLoader)
        XCTAssertEqual(playerViewModel.defender, localized("DEFENDER"))
    }
    
    func test_playerMidfielder_isLocalized() {
        let playerViewModel = PlayerViewModel(playerLoader: MockPlayerViewModel.mockPlayerLoader)
        XCTAssertEqual(playerViewModel.midfielder, localized("MIDFIELDER"))
    }
    
    func test_playerForward_isLocalized() {
        let playerViewModel = PlayerViewModel(playerLoader: MockPlayerViewModel.mockPlayerLoader)
        XCTAssertEqual(playerViewModel.forward, localized("FORWARD"))
    }
    
    func test_playerCoach_isLocalized() {
        let playerViewModel = PlayerViewModel(playerLoader: MockPlayerViewModel.mockPlayerLoader)
        XCTAssertEqual(playerViewModel.coach, localized("COACH"))
    }
        
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "LigasEc"
        let bundle = Bundle(for: LeagueViewModel.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "LigasEc"
        let bundle = Bundle(for: LeagueViewModel.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
