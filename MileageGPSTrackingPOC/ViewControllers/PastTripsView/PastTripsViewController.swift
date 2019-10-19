//
//  PastTripsViewController.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 19/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit
import CoreLocation

class PastTripsViewController: UIViewController {

    //MARK: IBOutlets

    @IBOutlet weak var pastTripsTableView: UITableView!

    //MARK: Properties

    private lazy var trips = [Trip]()
    private let locationManager = LocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        getTrips { [weak self] (trips, success) in
            guard let `self` = self else { return }
            self.trips = trips
            self.pastTripsTableView.reloadData()
        }
    }

    //MARK: IBActions

    @IBAction func newTripButtonTapped(_ sender: Any) {
        newTrip()
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

    private func newTrip() {
        //Determine correct action
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestAlwaysAuthorization()
            break
        case .restricted, .denied:
            showPermissionsAlert()
            break

        case .authorizedWhenInUse:
            //TODO: Ask user again to update their settings to always in use
            continueToNewTrip()
            break

        case .authorizedAlways:
            continueToNewTrip()
            break
        @unknown default:
            fatalError("Unknown case")
        }
    }

    private func showPermissionsAlert() {
        let alert = UIAlertController.init(title: "Sorry", message: "Please enable your location services.",
                                           preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel) { _ in }
        let settings = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alert.addAction(cancel)
        alert.addAction(settings)
        present(alert, animated: true) {}
    }

    private func continueToNewTrip() {
        self.performSegue(withIdentifier: .tripView, sender: nil)
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

extension PastTripsViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case tripView = "TripViewController"
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .tripView:
      print("redirecting to trip view")
    }
  }
}
