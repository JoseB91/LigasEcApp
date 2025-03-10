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

    func test_leagueTitle_isLocalized() {
        let leagueViewModel = LeagueViewModel()
        XCTAssertEqual(leagueViewModel.title, localized("LEAGUE_VIEW_TITLE"))
    }
    
    //TODO: Add other localized
    
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
