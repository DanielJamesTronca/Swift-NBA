//
//  TeamRepository.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

protocol TeamRepository {
    
    func retrieveTeams(currentPage: Int, _ completion: @escaping (Result<TeamsJSONResponse, Error>) -> Void)

}
