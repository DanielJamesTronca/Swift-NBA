//
//  DataFactory.swift
//  NBA-appTests
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation

@testable import NBA_app

class DataFactory {
    
    // Fake data factory, data must be always the same!
    static func retrieveTeamsFake(_ completion: @escaping (Result<TeamsJSONResponse, Error>) -> Void) {
        let teamData = TeamsJSONResponse(
            data: [
                NBA_app.TeamJSONData(
                    id: 1,
                    abbreviation: "ATL",
                    city: "Atlanta",
                    conference: "East",
                    division: "Southeast",
                    fullName: "Atlanta Hawks",
                    name: "Hawks"
                ),
                NBA_app.TeamJSONData(
                    id: 2,
                    abbreviation: "BOS",
                    city: "Boston",
                    conference: "East",
                    division: "Atlantic",
                    fullName: "Boston Celtics",
                    name: "Celtics"
                ),
                NBA_app.TeamJSONData(
                    id: 3,
                    abbreviation: "BKN",
                    city: "Brooklyn",
                    conference: "East",
                    division: "Atlantic",
                    fullName: "Brooklyn Nets",
                    name: "Nets"
                ),
                NBA_app.TeamJSONData(
                    id: 4,
                    abbreviation: "CHA",
                    city: "Charlotte",
                    conference: "East",
                    division: "Southeast",
                    fullName: "Charlotte Hornets",
                    name: "Hornets"
                )
            ]
        )
        // For the time being we use completion to conform to network call
        completion(.success(teamData))
    }
}
