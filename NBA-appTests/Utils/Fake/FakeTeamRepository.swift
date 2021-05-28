//
//  FakeTeamRepository.swift
//  NBA-appTests
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation

@testable import NBA_app

class FakeTeamRepositorySuccess: TeamRepository {
    func retrieveTeams(currentPage: Int, _ completion: @escaping (Result<TeamsJSONResponse, Error>) -> Void) {
        // Add sleep here to simulate network call
        return DataFactory.retrieveTeamsFake(completion)
    }
}

class FakeTeamRepository404CodeFailure: TeamRepository {
    func retrieveTeams(currentPage: Int, _ completion: @escaping (Result<TeamsJSONResponse, Error>) -> Void) {
        let errorTemp = NSError(
            domain: "",
            code: 404,
            userInfo: nil
        )
        completion(.failure(errorTemp))
    }
}

class FakeTeamRepository500CodeFailure: TeamRepository {
    func retrieveTeams(currentPage: Int, _ completion: @escaping (Result<TeamsJSONResponse, Error>) -> Void) {
        let errorTemp = NSError(
            domain: "",
            code: 500,
            userInfo: nil
        )
        completion(.failure(errorTemp))
    }
}
