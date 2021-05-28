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
    
    private func mapJsonToTeamData(from json: TeamsJSONResponse) {
        json.data.forEach { (team) in
            let teamData: TeamData = TeamData(
                teamId: team.id,
                teamFullName: team.fullName,
                division: team.division,
                conference: team.conference,
                city: team.city,
                teamAbbreviation: team.abbreviation
            )
            self.teamList.append(teamData)
        }
    }
}
