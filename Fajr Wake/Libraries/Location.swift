//
//  LocationManager.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/19/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - struct Coordinate

public struct Coordinate {
    public let latitude: Double
    public let longitude: Double
}

// MARK: - enum LocationError

fileprivate enum LocationError: Error, LocalizedError {
    case deniedPermission
    case unknown
    case restricted
    case notDetermined
    
    var errorDescription: String? {
        switch self {
        case .deniedPermission:
            return NSLocalizedString("Permission Denied", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
        case .restricted:
            return NSLocalizedString("Location Services Restricted", comment: "")
        case .notDetermined:
            return NSLocalizedString("Permission Not Determined", comment: "")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .deniedPermission:
            return NSLocalizedString("You denied this app to use location.", comment: "")
        case .unknown:
            return NSLocalizedString("We encountered an unknown error when attempting to fetch your location.", comment: "")
        case .restricted:
            return NSLocalizedString("This app is not authorized to use location services.", comment: "")
        case .notDetermined:
            return NSLocalizedString("You haven't yet made a choice regarding whether this app can use location services.", comment: "")
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .deniedPermission:
            return NSLocalizedString("Open Settings->Privacy->LocationServices and allow this app to use location services.", comment: "")
        case .unknown:
            return NSLocalizedString("Please try again later.", comment: "")
        case .restricted:
            return NSLocalizedString("Check your restrictions on your Settings app and try again.", comment: "")
        case .notDetermined:
            return NSLocalizedString("Please go to your Settings app and try again.", comment: "")
        }
    }
}

// MARK: - class Location

internal class Location: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private var manager: CLLocationManager?
    internal var coordinateCompletion: ((_ coordinate: Coordinate?, _ error: Error?) -> Void)?
    
    internal var latestLocation: CLLocation? {
        return manager?.location
    }
    
    // MARK: - Location Manager Delegates
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            coordinateCompletion?(nil, LocationError.deniedPermission)
        case .restricted:
            coordinateCompletion?(nil, LocationError.restricted)
        default:
            manager.requestLocation()
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            coordinateCompletion?(Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), nil)
        }
        manager.stopUpdatingLocation()
        self.manager?.delegate = nil
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinateCompletion?(nil, error)
        manager.stopUpdatingLocation()
        self.manager?.delegate = nil
    }
    
    // MARK: - Methods
    
    internal func fetchUserLocation() {
        if manager == nil {
            manager = CLLocationManager()
        }
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager?.requestWhenInUseAuthorization()
    }
    
    internal func lookUpCurrentLocationInfo(completion: @escaping (_ name: String?) -> Void) {
        // Use the last reported location.
        
        if let lastLocation = self.manager?.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder
                .reverseGeocodeLocation(
                    lastLocation,
                    completionHandler: {
                        (placemarks, error) in
                        if error == nil {
                            let firstLocation = placemarks?[0]
                            if let locality = firstLocation?.locality, let country = firstLocation?.country {
                                completion("\(locality), \(firstLocation?.administrativeArea ?? country)")
                            } else {
                                // Couldn't get proper values
                                completion(nil)
                            }
                        }
                        else {
                            // An error occurred during geocoding.
                            completion(nil)
                        }
                })
        }
        else {
            // No location was available.
            completion(nil)
        }
    }
}



