//
//  Vehicles.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation

struct Vehicles {
    let items: [Vehicle]
}

extension Vehicles: Decodable {

    enum CodingKeys: String, CodingKey {
        case items = "poiList"
    }
}
