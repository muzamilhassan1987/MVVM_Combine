//
//  Entities.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation

struct Vehicle {
    let id: Int
    let state: String?
    let type: String?
    let heading: Double?
    let coordinate: Coordinate?
}

extension Vehicle: Hashable {
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Vehicle: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case state
        case type
        case heading
        case coordinate
    }
}

struct Coordinate {
    let latitude: Double
    let longitude: Double
 
}

extension Coordinate: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
