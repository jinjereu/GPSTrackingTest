//
//  Settings.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation
import CoreLocation

class AppSettings {

    var activityType: CLActivityType
    var accuracy: LocationAccuracy
    var distanceFilter: LocationDistanceFilter

    var howRecentThreshold: HowRecentThreshold
    var horizontalAccuracyThreshold: LocationHorizontalAccuracyThreshold

    init(activityType: CLActivityType, accuracy: LocationAccuracy, distanceFilter: LocationDistanceFilter, howRecentThreshold: HowRecentThreshold, horizontalAccuracyThreshold: LocationHorizontalAccuracyThreshold) {
        self.activityType = activityType
        self.accuracy = accuracy
        self.distanceFilter = distanceFilter
        self.howRecentThreshold = howRecentThreshold
        self.horizontalAccuracyThreshold = horizontalAccuracyThreshold
    }

}
