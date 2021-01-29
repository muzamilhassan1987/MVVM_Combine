//
//  VehicleListViewModel.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit
import Combine

final class VehicleListViewModel: VehicleListViewModelType {

    private weak var navigator: VehicleListNavigator?
    private let useCase: VehicleUseCaseType
    private var cancellables: [AnyCancellable] = []

    init(useCase: VehicleUseCaseType, navigator: VehicleListNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    init(useCase: VehicleUseCaseType) {
        self.useCase = useCase
    }

    func transform(input: VehicleListViewModelInput) -> VehicleListViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        input.selection
            .sink(receiveValue: { [unowned self] _ in self.navigator?.showDetails() })
            .store(in: &cancellables)

        let vehicleDetails = input.appear
            .flatMapLatest({[unowned self] (p2Lat, p1Lon, p1Lat, p2Lon) in self.useCase.searchVehicles(with: p2Lat, p1Lon: p1Lon, p1Lat: p1Lat, p2Lon: p2Lon) })
            .map({ result -> VehicleListState in
                switch result {
                case .success([]): return .noResults
                case .success(let vehicles): return .success(self.viewModels(from: vehicles))
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let loading: VehicleListViewModelOuput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        return Publishers.Merge(loading, vehicleDetails).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModels(from vehicles: [Vehicle]) -> [VehicleViewModel] {
        return vehicles.map({[unowned self] vehicle in
            return VehicleViewModelBuilder.viewModel(from: vehicle)
        })
    }

}
