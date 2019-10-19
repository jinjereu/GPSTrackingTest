//
//  SettingsViewController.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 18/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit
import CoreLocation

protocol SettingsViewControllerDelegate: class {
    func settingsViewDidDismiss(with settings: AppSettings)
}

enum SettingsViewSection: Int {
    case activityType = 0
    case accuracy = 1
    case distanceFilter = 2
    case howRecentThreshold = 3
    case horizontalAccuracyThreshold = 4
}

class SettingsViewController: UIViewController {

    //MARK: IBOutlet

    @IBOutlet weak var tableView: UITableView!

    //MARK: Properties

    weak var delegate: SettingsViewControllerDelegate?
    internal lazy var appSettings: AppSettings = AppSettingsServices.shared.getAppSettings()

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Location Settings"
    }

    //MARK: IBActions

    @IBAction func doneButtonTapped(_ sender: Any) {
        AppSettingsServices.shared.setAppSettings(appSettings)
        delegate?.settingsViewDidDismiss(with: appSettings)
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func resetButtonTapped(_ sender: Any) {
        appSettings = AppSettingsServices.shared.resetAppSettings()
        tableView.reloadData()
    }


}
