//
//  PlayerDetail.swift
//  LigasEcApp
//
//  Created by José Briones on 8/7/26.
//

import Foundation

public struct PlayerDetail: Hashable, Identifiable {
    
    public let id: String
    public let name: String
    public let countryName: String?
    public let imagePath: URL?
    public let birthdayTime: Date?
    public let typeID: Int?
    public let typeName : String?
    public let teamImage: String?
    public let teamName: String?

    
    public init(id: String, name: String, countryName: String?, imagePath: URL?, birthdayTime: Date? = Date(), typeID: Int?, typeName: String?, teamImage: String?, teamName: String?) {
        self.id = id
        self.name = name
        self.countryName = countryName
        self.imagePath = imagePath
        self.birthdayTime = birthdayTime
        self.typeID = typeID
        self.typeName = typeName
        self.teamImage = teamImage
        self.teamName = teamName
    }

    public static let empty = PlayerDetail(id: "",
                                           name: "",
                                           countryName: nil,
                                           imagePath: nil,
                                           birthdayTime: nil,
                                           typeID: nil,
                                           typeName: nil,
                                           teamImage: nil,
                                           teamName: nil)
}

