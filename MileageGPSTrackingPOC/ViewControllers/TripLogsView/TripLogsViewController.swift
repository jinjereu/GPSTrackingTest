//
//  TripLogsViewController.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 17/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit
import CoreLocation

class TripLogsViewController: UIViewController {

    var locationList: [CLLocation]?

    @IBOutlet weak var textview: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //MARK: Private Methods

    private func setupView() {
        //Show the trip logs
        guard let locations = locationList else { fatalError("There are no locations to log") }

        var locationLogs = ""
        for location in locations {
            locationLogs += "\nNew Location - [Lat] \(location.coordinate.latitude), [Long] \(location.coordinate.longitude)"
        }
        textview.text = locationLogs
    }

}
