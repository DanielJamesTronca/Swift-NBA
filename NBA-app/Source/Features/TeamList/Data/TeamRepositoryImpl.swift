//
//  TeamRepositoryImpl.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class TeamRepositoryImpl: TeamRepository {
    
    func retrieveTeams(currentPage: Int, _ completion: @escaping (Result<TeamsJSONResponse, Error>) -> Void) {
        let urlString: String = "https://free-nba.p.rapidapi.com/teams?page=0"
        RemoteDataSource.shared.execute(urlString, requestType: .get, completion: completion)
    }
}
