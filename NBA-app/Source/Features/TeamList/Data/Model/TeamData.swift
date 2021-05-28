//
//  TeamData.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class TeamData {
    let teamId: Int
    let teamFullName: String
    let division: String
    let conference: String
    let city: String
    let teamAbbreviation: String
    
    init(teamId: Int, teamFullName: String, division: String, conference: String, city: String, teamAbbreviation: String) {
        self.teamId = teamId
        self.teamFullName = teamFullName
        self.division = division
        self.conference = conference
        self.city = city
        self.teamAbbreviation = teamAbbreviation
    }
}
