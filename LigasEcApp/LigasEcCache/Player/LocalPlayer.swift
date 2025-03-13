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
    public let position: String
    public let photoURL: URL?
    
    public init(id: String, name: String, position: String, photoURL: URL?) {
        self.id = id
        self.name = name
        self.position = position
        self.photoURL = photoURL
    }
}
