//
//  VehicleViewModelBuilder.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation
import Combine

struct VehicleViewModelBuilder {
    static func viewModel(from vehicle: Vehicle) -> VehicleViewModel {
        
        return VehicleViewModel(id: vehicle.id, state: vehicle.state ?? "", type: vehicle.type ?? "", heading: vehicle.heading ?? 0.0, coordinate: vehicle.coordinate ?? Coordinate(latitude: 0.0, longitude: 0.0))
        
    }
}


