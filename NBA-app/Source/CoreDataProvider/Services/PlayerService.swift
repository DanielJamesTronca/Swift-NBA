//
//  PlayerService.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation
import CoreData

struct PlayerService {
    
    let context: NSManagedObjectContext
    
    func createPlayer(name: String, teamId: Int64, playerId: Int64, teamFullName: String, position: String) -> PlayerCoreDataClass {
        let player = PlayerCoreDataClass(context: context)
        player.completeName = name
        player.teamId = teamId
        player.playerId = playerId
        player.teamFullName = teamFullName
        player.position = position
        return player
    }
}
