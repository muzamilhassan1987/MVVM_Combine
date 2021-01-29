//
//  VehicleUseCase.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation
import Combine
import UIKit.UIImage
import Network
protocol VehicleUseCaseType {

    /// Runs vehicles search with a query string
    func searchVehicles(with p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double) -> AnyPublisher<Result<[Vehicle], Error>, Never>

    /// Fetches details for vehicle with specified id
    //func vehicleDetails(with id: Int) -> AnyPublisher<Result<Vehicle, Error>, Never>

}

final class VehicleUseCase: VehicleUseCaseType {

    private let networkService: NetworkServiceType
//    private let imageLoaderService: ImageLoaderServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
       // self.imageLoaderService = imageLoaderService
    }

    func searchVehicles(with p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double) -> AnyPublisher<Result<[Vehicle], Error>, Never> {
        return networkService
            .load(Resource<Vehicles>.vehicles(p2Lat: p2Lat, p1Lon: p1Lon, p1Lat: p1Lat, p2Lon: p2Lon))
            .map({ (result: Result<Vehicles, NetworkError>) -> Result<[Vehicle], Error> in
                switch result {
                case .success(let vehicles): return .success(vehicles.items)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
///Not implemented
//    func vehicleDetails(with id: Int) -> AnyPublisher<Result<Vehicle, Error>, Never> {
//        return networkService
//            .load(Resource<Vehicle>.details(vehicleId: id))
//            .map({ (result: Result<Vehicle, NetworkError>) -> Result<Vehicle, Error> in
//                switch result {
//                case .success(let vehicle): return .success(vehicle)
//                case .failure(let error): return .failure(error)
//                }
//            })
//            .subscribe(on: Scheduler.backgroundWorkScheduler)
//            .receive(on: Scheduler.mainScheduler)
//            .eraseToAnyPublisher()
//    }


}
