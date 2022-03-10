//
//  LocationManager.swift
//  lekcija3
//
//  Created by karlis.berzins on 09/03/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
  private let locationManager = CLLocationManager()

  override init() {
    super.init()

    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
}
