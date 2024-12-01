//
//  LocationViewModel.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import CoreLocation
import Foundation

class LocationViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var userLocation: CLLocation? = nil
    @Published var hasUserLocation = false
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            hasUserLocation = true
        default:
            hasUserLocation = false
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        hasUserLocation = false
    }
}

