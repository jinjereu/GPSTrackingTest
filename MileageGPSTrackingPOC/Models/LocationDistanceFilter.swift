//
//  LocationDistanceFilter.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationDistanceFilter: CLLocationDistance {
    case none = 0
    case ten = 10
    case twenty = 20
    case thirty = 30
    case fourty = 40

    static let allValues: [LocationDistanceFilter] = [.none, .ten, .twenty, .thirty, .fourty]
}
