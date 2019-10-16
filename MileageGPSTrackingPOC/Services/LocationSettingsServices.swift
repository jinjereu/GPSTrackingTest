//
//  LocationSettingsServices.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 19/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation



class LocationSettingsServices {

    static let shared = LocationSettingsServices()

    private var locationSettings: LocationSettings

    private init() {
        locationSettings = LocationSettings.init(activityType: .fitness,
                              accuracy: .nearestTenMeters,
                              distanceFilter: .ten)
    }

    func getLocationSettings() -> LocationSettings {
        return locationSettings
    }

    func setLocationSettings(_ settings: LocationSettings) {
        locationSettings = settings
    }

}
