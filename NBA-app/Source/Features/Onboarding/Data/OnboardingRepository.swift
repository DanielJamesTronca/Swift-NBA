//
//  OnboardingRepository.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

protocol OnboardingRepository {
    
    func retrievePlayers(currentPage: Int, pageLimit: Int, _ completion: @escaping (Result<PlayersJSONResponse, Error>) -> Void)
    
    func addPlayer(dataProvider: TeamPlayerProvider, name: String, teamId: Int64, playerId: Int64, teamFullName: String, position: String)
    
    func checkIfDataContainsPlayerId(dataProvider: TeamPlayerProvider, id: Int) -> Bool
    
    func getTotalPlayerCount(dataProvider: TeamPlayerProvider) -> Int
    
}
