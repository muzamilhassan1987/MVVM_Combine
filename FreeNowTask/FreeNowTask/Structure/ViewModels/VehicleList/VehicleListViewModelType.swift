//
//  VehicleListViewModelType.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Combine

struct VehicleListViewModelInput {
    let appear: AnyPublisher<(p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double), Never>
    let search: AnyPublisher<(p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double), Never>
    let selection: AnyPublisher<Void, Never>
}

enum VehicleListState {
    case idle
    case loading
    case success([VehicleViewModel])
    case noResults
    case failure(Error)
}

extension VehicleListState: Equatable {
    static func == (lhs: VehicleListState, rhs: VehicleListState) -> Bool {
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

typealias VehicleListViewModelOuput = AnyPublisher<VehicleListState, Never>

protocol VehicleListViewModelType {
    func transform(input: VehicleListViewModelInput) -> VehicleListViewModelOuput
}

