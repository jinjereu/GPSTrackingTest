//
//  LocationThreshold.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 20/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationHorizontalAccuracyThreshold: CLLocationAccuracy {
    case none = 0
    case ten = 10
    case twenty = 20
    case thirty = 30
    case fourty = 40

    static let allValues: [LocationHorizontalAccuracyThreshold] = [.none, .ten, .twenty, .thirty, .fourty]
}

enum HowRecentThreshold: TimeInterval {
    case none = 0
    case ten = 10
    case twenty = 20
    case thirty = 30
    case fourty = 40

    static let allValues: [HowRecentThreshold] = [.none, .ten, .twenty, .thirty, .fourty]
}
