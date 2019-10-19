//
//  SettingsViewController+TableView.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit
import CoreLocation


extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SettingsViewSection.activityType.rawValue:
            return "Activity Type"
        case SettingsViewSection.accuracy.rawValue:
            return "Location Accuracy"
        case SettingsViewSection.distanceFilter.rawValue:
            return "Location Distance Filter"
        case SettingsViewSection.howRecentThreshold.rawValue:
            return "How Recent Threshold"
        case SettingsViewSection.horizontalAccuracyThreshold.rawValue:
            return "Horizontal Accuracy Threshold"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SettingsViewSection.activityType.rawValue:
            return CLActivityType.allValues.count
        case SettingsViewSection.accuracy.rawValue:
            return LocationAccuracy.allValues.count
        case SettingsViewSection.distanceFilter.rawValue:
            return LocationDistanceFilter.allValues.count
        case SettingsViewSection.howRecentThreshold.rawValue:
            return HowRecentThreshold.allValues.count
        case SettingsViewSection.horizontalAccuracyThreshold.rawValue:
            return LocationHorizontalAccuracyThreshold.allValues.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsOptionCell") else {
            return UITableViewCell()
        }

        return prepare(cell, at: indexPath)
    }

    func prepare(_ cell: UITableViewCell, at indexPath: IndexPath) -> UITableViewCell {

        let settings = appSettings

        var textLabel = ""
        var accessoryType = UITableViewCell.AccessoryType.none

        switch indexPath.section {
        case SettingsViewSection.activityType.rawValue:
            let activityType = CLActivityType.allValues[indexPath.row]
            textLabel = activityType.displayName
            accessoryType = settings.activityType == activityType ? .checkmark : .none
        case SettingsViewSection.accuracy.rawValue:
            let accuracy = LocationAccuracy.allValues[indexPath.row]
            textLabel = accuracy.displayName
            accessoryType = settings.accuracy == accuracy ? .checkmark : .none
        case SettingsViewSection.distanceFilter.rawValue:
            let distanceFilter = LocationDistanceFilter.allValues[indexPath.row]
            textLabel = String(distanceFilter.rawValue)
            accessoryType = settings.distanceFilter == distanceFilter ? .checkmark : .none
        case SettingsViewSection.howRecentThreshold.rawValue:
            let threshold = HowRecentThreshold.allValues[indexPath.row]
            textLabel = String(threshold.rawValue)
            accessoryType = settings.howRecentThreshold == threshold ? .checkmark : .none
        case SettingsViewSection.horizontalAccuracyThreshold.rawValue:
            let threshold = LocationHorizontalAccuracyThreshold.allValues[indexPath.row]
            textLabel = String(threshold.rawValue)
            accessoryType = settings.horizontalAccuracyThreshold == threshold ? .checkmark : .none
        default:
            fatalError("Content not supported")
        }

        cell.textLabel?.text? = textLabel
        cell.accessoryType = accessoryType

        return cell
    }

}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let settings = appSettings

        switch indexPath.section {
        case SettingsViewSection.activityType.rawValue:
            settings.activityType = CLActivityType.allValues[indexPath.row]
        case SettingsViewSection.accuracy.rawValue:
            settings.accuracy = LocationAccuracy.allValues[indexPath.row]
        case SettingsViewSection.distanceFilter.rawValue:
            settings.distanceFilter = LocationDistanceFilter.allValues[indexPath.row]
        case SettingsViewSection.howRecentThreshold.rawValue:
            settings.howRecentThreshold = HowRecentThreshold.allValues[indexPath.row]
        case SettingsViewSection.horizontalAccuracyThreshold.rawValue:
            settings.horizontalAccuracyThreshold = LocationHorizontalAccuracyThreshold.allValues[indexPath.row]
        default:
            fatalError("Content not supported")
        }

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

}
