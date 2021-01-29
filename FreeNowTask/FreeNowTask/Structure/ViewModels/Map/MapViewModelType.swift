//
//  MapViewModelType.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation
import Combine
import UIKit
struct MapViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let search: AnyPublisher<String, Never>
    let selection: AnyPublisher<Int, Never>
}

enum MapState {
    case idle
    case loading
    case success([VehicleViewModel])
    case noResults
    case failure(Error)
}

extension MapState: Equatable {
    static func == (lhs: MapState, rhs: MapState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsVehicles), .success(let rhsVehicles)): return lhsVehicles == rhsVehicles
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias MapViewModelOuput = AnyPublisher<VehicleListState, Never>

protocol MapViewModelType {
    func transform(input: VehicleListViewModelInput) -> VehicleListViewModelOuput
}

