//
//  TestHelpers.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

import XCTest
import LigasEcAPI
import LigasEcApp

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func mockLeagueTable() -> Table {
    return Table.League
}

func mockTeamTable() -> Table {
    return Table.Team
}

func mockLeagues() -> (models: [League], local: [LocalLeague]) {
    let models = [mockLeague(), mockLeague()]
    let local = models.toLocal()
    return (models, local)
}

func mockLeague() -> League {
    return League(id: "IaFDigtm",
                  name: "LigaPro Serie A",
                  logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                  dataSource: .FlashLive)
}

func mockTeams() -> (models: [Team], local: [LocalTeam]) {
    let models = [mockTeam(), mockTeam()]
    let local = models.toLocal()
    return (models, local)
}

func mockTeam() -> Team {
    return Team(id: "pCMG6CNp",
                name: "Barcelona SC",
                logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!,
                dataSource: .FlashLive)
}

func mockPlayers() -> (models: [Player], local: [LocalPlayer]) {
    let models = [mockPlayer(), mockPlayer()]
    let local = models.toLocal()
    return (models, local)
}

func mockPlayer() -> Player {
    return Player(id: "S0nWKdXm",
                  name: "Contreras Jose",
                  number: 1,
                  position: "Portero",
                  flagId: 205,
                  photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                  dataSource: .FlashLive)
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }

    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
