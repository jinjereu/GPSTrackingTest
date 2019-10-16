//
//  Location+MKAnnotation.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 17/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import Foundation
import MapKit

enum LocationType {
    case start
    case end
    case other
}

extension Location: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }
}

class LocationAnnotationView: MKAnnotationView {
    var type: LocationType?
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = false
            switch type {
            case .start:
                backgroundColor = .systemGreen
            case .end:
                backgroundColor = .systemBlue
            default:
                print("No changess needed")
            }
        }
    }
}

