//
//  PlayerDetailMapper.swift
//  LigasEcApp
//
//  Created by José Briones on 8/7/26.
//

import Foundation

public final class PlayerDetailMapper {
    
    // MARK: - Root
    
    // MARK: - Users
    private struct Root: Codable {
        let data: DATAClass
        
        var playerDetail: PlayerDetail {
            return PlayerDetail(id: data.id,
                                name: data.name,
                                countryName: data.countryName,
                                imagePath: data.imagePath,
//                                birthdayTime: data.birthdayTime,
                                typeID: data.typeID,
                                typeName: data.typeName,
                                teamImage: data.teamImage,
                                teamName: data.teamName)
        }
        
        enum CodingKeys: String, CodingKey {
            case data = "DATA"
        }
        
        // MARK: - DATAClass
        struct DATAClass: Codable {
            let id, layout, shortName: String
            let genderID, countryID: Int
            let countryName: String
            let imagePath: URL
            let imm, imageWidth, imageID, ime: String
            let name, birthdayTime: String
            let typeID: Int
            let typeName, tab, parentName, pmv: String
            let pce, pci, teamID: String
            let teamParticipantType: Int
            let teamImage: String
            let teamName: String
            let sportID: Int
            
            enum CodingKeys: String, CodingKey {
                case id = "ID"
                case layout = "LAYOUT"
                case shortName = "SHORT_NAME"
                case genderID = "GENDER_ID"
                case countryID = "COUNTRY_ID"
                case countryName = "COUNTRY_NAME"
                case imagePath = "IMAGE_PATH"
                case imm = "IMM"
                case imageWidth = "IMAGE_WIDTH"
                case imageID = "IMAGE_ID"
                case ime = "IME"
                case name = "NAME"
                case birthdayTime = "BIRTHDAY_TIME"
                case typeID = "TYPE_ID"
                case typeName = "TYPE_NAME"
                case tab = "TAB"
                case parentName = "PARENT_NAME"
                case pmv = "PMV"
                case pce = "PCE"
                case pci = "PCI"
                case teamID = "TEAM_ID"
                case teamParticipantType = "TEAM_PARTICIPANT_TYPE"
                case teamImage = "TEAM_IMAGE"
                case teamName = "TEAM_NAME"
                case sportID = "SPORT_ID"
            }
        }
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> PlayerDetail {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.playerDetail
        } catch {
            throw error
        }
    }
}
