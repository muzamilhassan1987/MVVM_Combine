//
//  VehicleListFlowCoordinator.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit

/// The `VehicleListFlowCoordinator` takes control over the flows on the vehicle list screen
class VehicleListFlowCoordinator: FlowCoordinator {
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: VehicleListFlowCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: VehicleListFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchController = self.dependencyProvider.vehicleListController(navigator: self)
        self.rootController.setViewControllers([searchController], animated: false)
    }

}

extension VehicleListFlowCoordinator: VehicleListNavigator {

    func showDetails() {
        let controller = self.dependencyProvider.vehicleMapController()
        self.rootController.pushViewController(controller, animated: true)
    }

}
