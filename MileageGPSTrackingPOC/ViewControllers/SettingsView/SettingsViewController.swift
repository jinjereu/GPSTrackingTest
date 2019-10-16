//
//  SettingsViewController.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit
import CoreLocation

enum SettingsViewSection: Int {
    case activityType = 0
    case accuracy = 1
    case distanceFilter = 2
}

class SettingsViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!

    internal lazy var locationSettings: LocationSettings = LocationSettingsServices.shared.getLocationSettings()

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Location Settings"
    }

    //MARK: IBActions
    @IBAction func doneButtonTapped(_ sender: Any) {
        LocationSettingsServices.shared.setLocationSettings(locationSettings)
    }

}
