//
//  TripViewController.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 16/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum TripViewState {
    case new
    case tracking
    case saved
    case error
}

class TripViewController: UIViewController {

    //MARK: Outlets

    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitSwitch: UISwitch!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var startTripButton: UIButton!
    @IBOutlet weak var stopTripButton: UIButton!
    @IBOutlet weak var useTripButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    //MARK: Properties
    private var tripState: TripViewState?

    private var trip: Trip?
    private let locationManager = CLLocationManager()
    private var appSettings = AppSettingsServices.shared.getAppSettings()

    //TODO: Declare a ViewModel, Also create a helper for initializing the data
    //To track the duration of the run
    private var seconds = 0
    //Used to update the UI per second
    private var timer: Timer?
    //Hold the cumulative distance
    private var distanceTravelled: Measurement<UnitLength> = Measurement(value: 0, unit: UnitLength.meters)
    //Hold all the locations detectied
    private var locationList: [CLLocation] = []
    //Hold value for the selected unit from the toggle
    private var selectedUnit: UnitLength = .miles {
        didSet {
            //Update the view
            unitLabel.text = "Unit: \(selectedUnit.name)"
        }
    }

    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewState(.new)
        setupLocationManager()

        selectedUnit = .miles
        distanceTravelled = Measurement(value: 0, unit: UnitLength.meters)
    }

    //MARK: IBActions

    @IBAction func startTripTapped(_ sender: Any) {
        startTrip()
    }

    @IBAction func stopTripTapped(_ sender: Any) {
        //Confirm if you want to end the trip
        let alertController = UIAlertController(title: "End trip?",
                                                message: "Do you wish to end your trip?",
                                                preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            self.stopTrip()
            //Save the trip details
            self.saveTrip()

            //Also get the start and end addresses
            self.getAddresses()
            //TODO: Its probably easier to verify the address if the map is shown too
            self.loadMap()

            self.updateViewState(.saved)
        })

        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            guard let `self` = self else { return }
            self.stopTrip()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })

        present(alertController, animated: true)
    }

    @IBAction func useDetailsTapped(_ sender: Any) {
        //TODO: Confirm that details will be used, so redirect to creating an expense for this trip
    }

    @IBAction func viewLogsTapped(_ sender: Any) {
        self.performSegue(withIdentifier: .tripLogs, sender: nil)
    }

    @IBAction func unitSwitchTapped(_ sender: Any) {
        //Depends on the value switch the unit
        selectedUnit = unitSwitch.isOn ? .miles: .kilometers
    }

    //MARK: View Logic

    private func updateViewState(_ state: TripViewState) {
        switch state {
        case .new:
            dataStackView.isHidden = false
            startTripButton.isHidden = false
            stopTripButton.isHidden = true
            distanceLabel.isHidden = true
            fromLabel.isHidden = true
            toLabel.isHidden = true
            useTripButton.isHidden = true
            unitSwitch.isHidden = false
            mapView.isHidden = true
        case .tracking:
            startTripButton.isHidden = true
            stopTripButton.isHidden = false
            distanceLabel.isHidden = false
            fromLabel.isHidden = false
            toLabel.isHidden = true
            unitSwitch.isHidden = true
            mapView.isHidden = true
        case .saved:
            stopTripButton.isHidden = true
            fromLabel.isHidden = false
            toLabel.isHidden = false
            useTripButton.isHidden = false
            mapView.isHidden = false
        case .error:
            dataStackView.isHidden = false
            showErrorAlert()
        }
    }

    private func updateDisplay() {
        //TODO: Format the distance based on the unit selected
        let formattedDistance = FormatDisplay.distance(distanceTravelled, outputUnit: selectedUnit)
        distanceLabel.text = "Distance: \(formattedDistance)"
    }

    //MARK: Application Logic

    private func setupLocationManager() {
        locationManager.activityType = appSettings.activityType
        locationManager.distanceFilter = appSettings.distanceFilter.rawValue
        locationManager.desiredAccuracy = appSettings.accuracy.rawValue
        locationManager.delegate = self
    }

    private func startTrip() {
        updateViewState(.tracking)

        //Initialize the data again
        seconds = 0
        distanceTravelled = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        //TODO: Thinking about putting this in updateViewState although
        //can also be separate since its only for the distance labels...
        updateDisplay()

        //Starts the timer so that each second it is able to update the display
        //TODO: Ensure this is running properly with background mode
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }

        startLocationUpdates()
    }

    private func eachSecond() {
      seconds += 1
      updateDisplay()
    }

    private func stopTrip() {
        //When the end the run stop tracking the location
        locationManager.stopUpdatingLocation()
    }

    private func saveTrip() {
        let newTrip = Trip(context: CoreDataStack.context)
        newTrip.distance = distanceTravelled.value
        newTrip.duration = Int16(seconds)
        newTrip.timestamp = Date()

        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newTrip.addToLocations(locationObject)
        }

        CoreDataStack.saveContext()

        trip = newTrip
    }

    private func getAddresses() {
        //Get the addresses
        guard let startLocation = locationList.first, let endLocation = locationList.last else { return }

        self.getFormattedAddressLines(for: startLocation) { addressLines in
            var addressStr = ""
            for address in addressLines {
                addressStr += "\(address) \n"
            }
            self.fromLabel.text = "From: " + addressStr
        }

        self.getFormattedAddressLines(for: endLocation) { addressLines in
            var addressStr = ""
            for address in addressLines {
                addressStr += "\(address) \n"
            }
            self.toLabel.text = "To: " + addressStr
        }
    }

    //TODO: Put the next two in extension/helper
    func getFormattedAddressLines(for location: CLLocation, completionHandler: @escaping (NSArray) -> Void ) {
        self.lookupAddress(for: location) { placemark in
            if let placemark = placemark,
                let formattedAddressLines = placemark.addressDictionary?["FormattedAddressLines"] as? NSArray {
                print("Address for location: \(formattedAddressLines)")
                completionHandler(formattedAddressLines)
            } else {
                completionHandler([])
            }
        }
    }

    func lookupAddress(for location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        let geocoder = CLGeocoder()

        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
             // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }

    private func showErrorAlert() {
        let alert = UIAlertController.init(title: "Sorry", message: "Something went wrong.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true) {}
    }

    private func startLocationUpdates() {
        //TODO: Check pausesLocationUpdatesAutomatically in order to restart the location services when it is
        //automatically paused by the system
        locationManager.startUpdatingLocation()
    }

}

extension TripViewController {

    private func loadMap() {
        guard
            let locations = trip?.locations,
            locations.count > 0,
            let region = mapRegion()
        else {
            let alert = UIAlertController(title: "Error",
                                        message: "Sorry, this trip has no locations saved",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }

        mapView.isUserInteractionEnabled = false
        mapView.delegate = self
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(tripRoute())

        guard
            let startLocation = trip?.locations?.firstObject as? Location,
            let endLocation = trip?.locations?.lastObject as? Location
            else {
                return
        }

        var startLoc = startLocation
        startLoc.isStart = true
        mapView.addAnnotation(startLoc)
        mapView.addAnnotation(endLocation)
    }

    private func mapRegion() -> MKCoordinateRegion? {
        guard let locations = trip?.locations, locations.count > 0 else {
            return nil
        }

        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }

        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }

          let maxLat = latitudes.max()!
          let minLat = latitudes.min()!
          let maxLong = longitudes.max()!
          let minLong = longitudes.min()!

          let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                              longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2.5,
                                      longitudeDelta: (maxLong - minLong) * 2.5)
          return MKCoordinateRegion(center: center, span: span)
    }

    private func tripRoute() -> MKPolyline {
        guard let locations = trip?.locations else {
            return MKPolyline()
        }

        let coordinates: [CLLocationCoordinate2D] = locations.map({ location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        })

        return MKPolyline.init(coordinates: coordinates, count: coordinates.count)
    }

}

extension TripViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3

        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

      guard let annotation = annotation as? Location else { return nil }

      let identifier = "marker"
        if #available(iOS 11.0, *) {
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
              as? MKMarkerAnnotationView {
              dequeuedView.annotation = annotation
              view = dequeuedView
            } else {
              view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)

                //TODO: Extend location so you can specify its type and be able to present appropriate marker tint color for this type

                view.markerTintColor = annotation.isStart ? .systemGreen : .systemRed
              return view
            }
        } else {
            // Fallback on earlier versions
            fatalError("You haven't defined for lower versions")
        }
        return nil

    }

}

extension TripViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //TODO: Check again for location services bearing in mind whatever current state you are in as well
        //checkLocationServices()
    }

    //This one will be called whenever the user's location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

      for newLocation in locations {
        //Order the location by time and how recent it is
        let howRecent = newLocation.timestamp.timeIntervalSinceNow

        //Also checking the accuracy of the reading. If the device isnt confident that it is not within 20 meters of user's actual location don't consider this data at all
        guard newLocation.horizontalAccuracy < appSettings.horizontalAccuracyThreshold.rawValue
            && abs(howRecent) < appSettings.howRecentThreshold.rawValue else { continue }
        //For testing can commented the above one out so it can properly track the locations when just walking

        if let lastLocation = locationList.last {
          //Calculating the distance from the last location
          let delta = newLocation.distance(from: lastLocation)
          //Adding the traveled distance to the totalDistanceTravelled
          distanceTravelled = distanceTravelled + Measurement(value: delta, unit: UnitLength.meters)
        }

        //If location list is just one item it should mean that this is the first location ever
        //TODO: Get the adress of the first location
        locationList.append(newLocation)
      }
    }
}

extension TripViewController: SettingsViewControllerDelegate {
    func settingsViewDidDismiss(with settings: AppSettings) {
        appSettings = settings
        setupLocationManager()
    }
}

extension TripViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case tripLogs = "TripLogsViewController"
        case locationSettings = "LocationSettingsViewController"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .tripLogs:
            let destination = segue.destination as! TripLogsViewController
            destination.locationList = locationList
        case .locationSettings:
            if let nav = segue.destination as? UINavigationController,
                let destination = nav.children.first as? SettingsViewController {
                destination.delegate = self
            }
        }
    }
}
