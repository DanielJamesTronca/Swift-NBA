//
//  PlayersData.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

// MARK: - PlayersData
struct PlayersJSONResponse: Codable {
    let data: [Datum]
    let meta: Meta
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let firstName, lastName, position: String
    let team: Team
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case position, team
    }
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let abbreviation, city, conference, division: String
    let fullName, name: String
    
    enum CodingKeys: String, CodingKey {
        case id, abbreviation, city, conference, division
        case fullName = "full_name"
        case name
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalPages, currentPage, nextPage, perPage: Int
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case nextPage = "next_page"
        case perPage = "per_page"
        case totalCount = "total_count"
    }
}
