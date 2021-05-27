//
//  OnboardingRepository.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

protocol OnboardingRepository {
    func retrievePlayers(currentPage: Int, pageLimit: Int, _ completion: @escaping (Result<PlayersJSONResponse, Error>) -> Void) 
}
