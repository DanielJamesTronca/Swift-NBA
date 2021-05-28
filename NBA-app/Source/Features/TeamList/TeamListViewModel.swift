//
//  TeamListViewModel.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation
import UIKit
import CoreData

class TeamListViewModel {
    
    // Team list
    var teamList: [TeamData] = []
    // Filtered team list
    var filteredTeams: [TeamData] = []
    // Current page
    private var currentTeamsPage: Int = 1
    
    var player: [NSManagedObject] = []

    // Team repository to handle data
    private let teamRepository: TeamRepository
    // Team repository initialization
    init(teamRepository: TeamRepository) {
        self.teamRepository = teamRepository
    }
    
    // This call is not paginating! The api has max page = 1
    func retrieveAllTeams(completionHandler: @escaping (_ error: ErrorStructure?) -> Void) {
        self.teamRepository.retrieveTeams(currentPage: self.currentTeamsPage) { (response) in
            switch response {
            case .success(let teams):
                print("Success")
                if !teams.data.isEmpty {
                    self.mapJsonToTeamData(from: teams)
                }
                completionHandler(nil)
            case .failure(let error):
                print(error.localizedDescription)
                // Sample error code for testing purposes (See SatispayExcerciseTest)!
                // Extend error code managaement! (Alamofire would be nice!)
                let errorStructure: ErrorStructure = error.mapNetworkErrorToUIErrorData(errorCode: 404)
                completionHandler(errorStructure)
            }
        }
    }
    
//    func retrievePlayers(teamId: Int) -> [PlayersData] {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return []
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
//
//        var playerArray: [PlayersData] = []
//
//        do {
//            player = try managedContext.fetch(fetchRequest)
//
//            let playerTeam = player.filter{ $0.value(forKeyPath: "teamId") as? Int == teamId }
//
//            playerTeam.forEach { (player) in
//                if let playerName = player.value(forKeyPath: "completeName") as? String,
//                   let teamFullName = player.value(forKeyPath: "teamFullName") as? String,
//                   let teamId = player.value(forKeyPath: "teamId") as? Int,
//                   let playerId = player.value(forKeyPath: "playerId") as? Int {
//                    let playerData: PlayersData = PlayersData(completeName: playerName, playerId: playerId, teamFullName: teamFullName, teamId: teamId)
//                    playerArray.append(playerData)
//                }
//            }
//            return playerArray
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//            return []
//        }
//    }
    
    private func mapJsonToTeamData(from json: TeamsJSONResponse) {
        json.data.forEach { (team) in
            let teamData: TeamData = TeamData(
                teamId: team.id,
                teamFullName: team.fullName,
                division: team.division,
                conference: team.conference,
                city: team.city
            )
            self.teamList.append(teamData)
        }
    }
}
