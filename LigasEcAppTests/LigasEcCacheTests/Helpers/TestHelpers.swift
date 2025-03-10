//
//  TestHelpers.swift
//  LigasEcAppTests
//
//  Created by José Briones on 10/3/25.
//

import XCTest
import LigasEcAPI
import LigasEcApp

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

func mockTeams() -> (models: [Team], local: [LocalTeam]) {
    let models = [mockTeam(), mockTeam()]
    let local = models.toLocal()
    return (models, local)
}

func mockTeam() -> Team {
    return Team(id: "pCMG6CNp",
                name: "Barcelona SC",
                logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!)
}
