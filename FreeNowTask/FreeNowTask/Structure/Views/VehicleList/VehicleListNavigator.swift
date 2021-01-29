//
//  VehiclesSearchNavigator.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation

protocol VehicleListNavigator: /*AutoMockable, */AnyObject {
    /// Presents the vehicle details screen
    func showDetails()
}
