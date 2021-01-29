//
//  VehicleViewModel.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation
import UIKit
import Combine

struct VehicleViewModel {
    let id: Int
    let state: String
    let type: String
    let heading: Double
    let coordinate : Coordinate
    init(id: Int, state: String, type: String, heading: Double, coordinate: Coordinate) {
        self.id = id
        self.state = state
        self.type = type
        self.heading = heading
        self.coordinate = coordinate
    }
}

extension VehicleViewModel: Hashable {
    static func == (lhs: VehicleViewModel, rhs: VehicleViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
