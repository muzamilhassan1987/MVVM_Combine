//
//  Resource+Vehicle.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation
import Network
extension Resource {
//p2Lat=53.394655&p1Lon=9.757589&p1Lat=53%20.694865&p2Lon=10.099891
    static func vehicles(p2Lat: Double,p1Lon: Double,p1Lat: Double,p2Lon: Double) -> Resource<Vehicles> {
        let url = ApiConstants.baseUrl
        let parameters: [String : CustomStringConvertible] = [
            "p2Lat": p2Lat,
            "p1Lon": p1Lon,
            "p1Lat": p1Lat,
            "p2Lon": p2Lon
            ]
        return Resource<Vehicles>(url: url, parameters: parameters)
    }
}
//https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891
