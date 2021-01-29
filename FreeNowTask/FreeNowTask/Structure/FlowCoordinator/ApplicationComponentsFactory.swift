//
//  ApplicationComponentsFactory.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit
import Network
/// The ApplicationComponentsFactory takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
    fileprivate lazy var useCase: VehicleUseCaseType = VehicleUseCase(networkService: servicesProvider.network)

    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {

    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        rootViewController.navigationBar.tintColor = UIColor.black
        return rootViewController
    }
}

extension ApplicationComponentsFactory: VehicleListFlowCoordinatorDependencyProvider {

    func vehicleListController(navigator: VehicleListNavigator) -> UIViewController {
        let viewModel = VehicleListViewModel(useCase: useCase, navigator: navigator)
        return VehicleListViewController(viewModel: viewModel)
    }

    func vehicleMapController() -> UIViewController {
  //      return MapViewController()
        let viewModel = VehicleListViewModel(useCase: useCase)
        return MapViewController(viewModel: viewModel)
    }
}
