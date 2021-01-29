//
//  MapViewModel.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//


import Foundation
import UIKit
import Combine
import MapKit

public class MapViewModel : NSObject {
    public let coordinate: CLLocationCoordinate2D
    let id: Int
    let state: String
    let type: String
    init(coordinate: CLLocationCoordinate2D,
                id: Int,
                state: String,
                type: String) {
      self.coordinate = coordinate
      self.id = id
      self.state = state
      self.type = type
    }
}

// MARK: - MKAnnotation
extension MapViewModel: MKAnnotation {
    
  public var title: String? {
    return state
  }
  
  public var subtitle: String? {
    return type
  }
}
