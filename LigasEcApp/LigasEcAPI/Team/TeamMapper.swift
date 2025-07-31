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
                                                    dataSource: .flashLive)
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
                                    dataSource: .transferMarket)
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
            if source == .flashLive {
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
