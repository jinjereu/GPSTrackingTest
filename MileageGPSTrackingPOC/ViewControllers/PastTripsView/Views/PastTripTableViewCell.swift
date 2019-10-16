//
//  PastTripTableViewCell.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 19/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit

class PastTripTableViewCell: UITableViewCell {

    static let id = "PastTripTableViewCell"

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCellDetail(for trip: Trip) {
        if let timestamp = trip.timestamp {
            self.dateLabel.text = "Trip On: \(FormatDisplay.date(timestamp))"
        } else {
            self.dateLabel.text = "--"
        }

        self.totalDistanceLabel.text = "Total Distance: \(FormatDisplay.distance(trip.distance))"

        if let startLocation = trip.startLocation {
            self.fromLabel.text = "From: \n\(startLocation)"
        } else {
            self.fromLabel.text = "From: --"
        }

        if let endLocation = trip.endLocation {
            self.toLabel.text = "To: \n\(endLocation)"
        } else {
            self.toLabel.text = "To: --"
        }
    }
    
}
