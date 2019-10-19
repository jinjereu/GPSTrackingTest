//
//  AppSettingsServices.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 19/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation

class AppSettingsServices {

    //MARK: Static Properties

    static let shared = AppSettingsServices()

    //MARK: Properties

    private var appSettings: AppSettings

    private init() {
        appSettings = AppSettings.init(activityType: .automotiveNavigation,
        accuracy: .best,
        distanceFilter: .ten,
        howRecentThreshold: .ten,
        horizontalAccuracyThreshold: .twenty)
    }

    //MARK: Public Methods

    func resetAppSettings() -> AppSettings {
        appSettings = AppSettings.init(activityType: .automotiveNavigation,
        accuracy: .best,
        distanceFilter: .ten,
        howRecentThreshold: .ten,
        horizontalAccuracyThreshold: .twenty)

        return appSettings
    }

    func getAppSettings() -> AppSettings {
        return appSettings
    }

    func setAppSettings(_ settings: AppSettings) {
        appSettings = settings
    }

}
