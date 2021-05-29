//
//  TeamJSONResponse.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

// MARK: - TeamData
struct TeamsJSONResponse: Codable {
    let data: [TeamJSONData]
//    let meta: Meta
}

// MARK: - Datum
struct TeamJSONData: Codable {
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
//struct Meta: Codable {
//    let totalPages, currentPage: Int
//    let nextPage: JSONNull?
//    let perPage, totalCount: Int
//
//    enum CodingKeys: String, CodingKey {
//        case totalPages = "total_pages"
//        case currentPage = "current_page"
//        case nextPage = "next_page"
//        case perPage = "per_page"
//        case totalCount = "total_count"
//    }
//}
