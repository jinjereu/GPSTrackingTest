//
//  PastTripsViewController.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 19/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit

class PastTripsViewController: UIViewController {

    @IBOutlet weak var pastTripsTableView: UITableView!

    private lazy var trips = [Trip]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        getTrips { [weak self] (trips, success) in
            guard let `self` = self else { return }
            self.trips = trips
            self.pastTripsTableView.reloadData()
        }
    }

    //MARK: Private Methods
    private func setupView() {
        title = "Trips"
        setupTableView()
    }

    private func setupTableView() {
        pastTripsTableView.register(UINib(nibName: PastTripTableViewCell.id, bundle: nil),
                                    forCellReuseIdentifier: PastTripTableViewCell.id)
        pastTripsTableView.rowHeight = UITableView.automaticDimension
        pastTripsTableView.estimatedRowHeight = 160
    }

    //MARK: Data

    private func getTrips(completion: @escaping (_ trips: Array<Trip>, _ success: Bool) -> Void) {
        do {
            trips = try CoreDataStack.context.fetch(Trip.fetchRequest())
            completion(trips, true)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion([], true)
        }
    }


}

extension PastTripsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PastTripTableViewCell.id) as? PastTripTableViewCell else {
            fatalError("Unexpected cell")
        }

        let trip = trips[indexPath.row]
        cell.setCellDetail(for: trip)

        return cell
    }

}
