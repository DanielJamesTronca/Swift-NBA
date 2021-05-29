//
//  PlayersDTO.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class PlayersData {
    let completeName: String
    let playerId: Int64
    let teamFullName: String
    let teamId: Int64
    let position: String
    
    init(completeName: String, playerId: Int64, teamFullName: String, teamId: Int64, position: String) {
        self.completeName = completeName
        self.playerId = playerId
        self.teamFullName = teamFullName
        self.teamId = teamId
        self.position = position
    }
}
