//
//  TeamListViewModel.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class TeamListViewModel {
    
    var teamList: [TeamData] = []
    
    var filteredTeams: [TeamData] = []
    
    // Team repository to handle data
    private let teamRepository: TeamRepository
    // Team repository initialization
    init(teamRepository: TeamRepository) {
        self.teamRepository = teamRepository
    }
    
    func retrieveAllTeams(completionHandler: @escaping (_ error: ErrorStructure?) -> Void) {
        self.teamRepository.retrieveTeams(currentPage: 0) { (response) in
            switch response {
            case .success(let teams):
                print("Success")
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
                teamFullName: team.fullName
            )
            self.teamList.append(teamData)
        }
    }
}
