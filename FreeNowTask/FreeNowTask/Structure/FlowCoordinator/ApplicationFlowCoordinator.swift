//
//  ApplicationFlowCoordinator.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit

/// The application flow coordinator. Takes responsibility about coordinating view controllers and driving the flow
class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider & VehicleListFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {

        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = UIColor.black

        self.window.rootViewController = navigationController

        let vehicleListFlowCoordinator = VehicleListFlowCoordinator(rootController: navigationController, dependencyProvider: self.dependencyProvider)
        vehicleListFlowCoordinator.start()

        self.childCoordinators = [vehicleListFlowCoordinator]
    }

}
