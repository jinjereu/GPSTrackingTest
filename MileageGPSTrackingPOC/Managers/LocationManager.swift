//
//  LocationManager.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 16/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
  func startLocationUpdates()
}

class LocationManager {
    static let shared = CLLocationManager()

    private init() {}
}


