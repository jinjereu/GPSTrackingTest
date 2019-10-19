//
//  LocationAccuracy.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation

enum LocationAccuracy: Double {
    case bestForNavigation
    case best
    case nearestTenMeters
    case hundredMeters
    case kilometer
    case threeKilometers

    var displayName: String {
        switch self {
        case .bestForNavigation:
            return "Best for navigation"
        case .best:
            return "Best"
        case .nearestTenMeters:
            return "Nearest Ten Meters"
        case .hundredMeters:
            return "Hundred Meters"
        case .kilometer:
            return "Kilometer"
        case .threeKilometers:
            return "Three Kilometers"
        }
    }

    static let allValues: [LocationAccuracy] = [.bestForNavigation, .best,
                                                .nearestTenMeters, .hundredMeters,
                                                .kilometer, .threeKilometers]
}
