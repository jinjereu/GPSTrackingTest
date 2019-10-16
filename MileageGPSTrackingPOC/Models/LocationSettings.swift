//
//  LocationSettings.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation
import CoreLocation

class LocationSettings {

    var activityType: CLActivityType
    var accuracy: LocationAccuracy
    var distanceFilter: LocationDistanceFilter

    init(activityType: CLActivityType, accuracy: LocationAccuracy, distanceFilter: LocationDistanceFilter) {
        self.activityType = activityType
        self.accuracy = accuracy
        self.distanceFilter = distanceFilter
    }

}
