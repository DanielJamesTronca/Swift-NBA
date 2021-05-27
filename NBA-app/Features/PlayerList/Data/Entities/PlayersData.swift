//
//  PlayersDTO.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class PlayersData {
    let completeName: String
    let playerId: Int
    let teamFullName: String
    let teamId: Int
    
    init(completeName: String, playerId: Int, teamFullName: String, teamId: Int) {
        self.completeName = completeName
        self.playerId = playerId
        self.teamFullName = teamFullName
        self.teamId = teamId
    }
}
