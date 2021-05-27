//
//  OnboardingRepositoryImplementation.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class OnboardingRepositoryImpl: OnboardingRepository {
    func retrievePlayers(currentPage: Int, pageLimit: Int, _ completion: @escaping (Result<PlayersJSONResponse, Error>) -> Void) {
        let urlString: String = "https://free-nba.p.rapidapi.com/players?per_page=\(pageLimit)&page=\(currentPage)"
        RemoteDataSource.shared.execute(urlString, requestType: .get, completion: completion)
    }
}
