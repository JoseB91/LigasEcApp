//
//  TeamMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation

public final class TeamMapper {
    
    private struct RootFlashLive: Codable {
        let data: [Datum]

        var teams: [Team] {
            guard let firstData = data.first else { return [] }
            return firstData.rows.compactMap { Team(id: $0.teamID,
                                                    name: $0.teamName,
                                                    logoURL: $0.teamImagePath,
                                                    dataSource: .FlashLive)
            }
        }

        enum CodingKeys: String, CodingKey {
            case data = "DATA"
        }
        
        struct Datum: Codable {
            let rows: [Row]

            enum CodingKeys: String, CodingKey {
                case rows = "ROWS"
            }
        }
        
        struct Row: Codable {
            let ranking: Int
            let teamName, teamID: String
            let teamImagePath: URL

            enum CodingKeys: String, CodingKey {
                case ranking = "RANKING"
                case teamName = "TEAM_NAME"
                case teamID = "TEAM_ID"
                case teamImagePath = "TEAM_IMAGE_PATH"
            }
        }

    }
    
    private struct RootTransferMarket: Codable {
        let clubs: [Club]
        
        var teams: [Team] {
            clubs.compactMap { Team(id: $0.id,
                                    name: $0.name,
                                    logoURL: $0.image,
                                    dataSource: .TransferMarket)
            }
        }

        struct Club: Codable {
            let id, name: String
            let image: URL
        }
    }
            
    public static func map(_ data: Data, from response: HTTPURLResponse, with source: DataSource) throws -> [Team] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            if source == .FlashLive {
                let root = try JSONDecoder().decode(RootFlashLive.self, from: data)
                return root.teams
            } else {
                let root = try JSONDecoder().decode(RootTransferMarket.self, from: data)
                return root.teams
            }            
        } catch {
            throw error
        }
    }
}

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

public enum MapperError: Error {
    case unsuccessfullyResponse
}

public struct Team: Hashable, Identifiable {
    public let id: String
    public let name: String
    public let logoURL: URL
    public let dataSource: DataSource
    
    public init(id: String, name: String, logoURL: URL, dataSource: DataSource) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
        self.dataSource = dataSource
    }
}

public enum DataSource {
    case FlashLive
    case TransferMarket
}
