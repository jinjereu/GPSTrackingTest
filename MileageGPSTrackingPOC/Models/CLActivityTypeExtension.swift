//
//  CLActivityTypeExtension.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation
import CoreLocation

extension CLActivityType {

    var displayName: String {
        switch self {
        case .automotiveNavigation:
            return "Automotive Navigation"
        case .fitness:
            return "Fitness"
        case .other:
            return "Other"
        case .otherNavigation:
            return "Other Navigation"
        default:
            fatalError("Unsupported activity type")
        }
    }

    static let allValues: [CLActivityType] = [.automotiveNavigation, .fitness, .other, .otherNavigation]

}
