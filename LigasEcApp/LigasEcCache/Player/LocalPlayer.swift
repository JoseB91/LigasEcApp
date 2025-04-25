//
//  LocalPlayer.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import Foundation
import LigasEcAPI

public struct LocalPlayer: Equatable {
    public let id: String
    public let name: String
    public let number: Int?
    public let position: String
    public let flagId: Int?
    public let nationality: String?
    public let photoURL: URL?
    
    public init(id: String, name: String, number: Int?, position: String, flagId: Int? = nil, nationality: String? = nil, photoURL: URL?) {
        self.id = id
        self.name = name
        self.number = number
        self.position = position
        self.flagId = flagId
        self.nationality = nationality
        self.photoURL = photoURL
    }
}
