//
//  LocationManager.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/19/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation
import CoreLocation

public struct Coordinates {
    public let latitude: Double
    public let longitude: Double
}

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
            return NSLocalizedString("Please configure your Settings app to allow this app to use location services.", comment: "")
        case .unknown:
            return NSLocalizedString("Please try again later.", comment: "")
        case .restricted:
            return NSLocalizedString("Check your restrictions on your Settings app and try again.", comment: "")
        case .notDetermined:
            return NSLocalizedString("Please go to your Settings app and try again.", comment: "")
        }
    }
}

internal protocol LocationDelegate: class {
    func location(_ location: Location, didReceiveCoordinates coordinates: Coordinates)
    func location(_ location: Location, didFailToReceiveCoordinates error: Error)
}

internal class Location: NSObject, CLLocationManagerDelegate {
    
    private var manager: CLLocationManager?
    weak var delegate: LocationDelegate?
    
    required init(delegate: LocationDelegate) {
        self.delegate = delegate
    }
    
    internal func fetchUserLocation() {
        if manager == nil {
            manager = CLLocationManager()
        }
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager?.requestWhenInUseAuthorization()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            delegate?.location(self, didFailToReceiveCoordinates: LocationError.deniedPermission)
        case .notDetermined:
            delegate?.location(self, didFailToReceiveCoordinates: LocationError.notDetermined)
        case .restricted:
            delegate?.location(self, didFailToReceiveCoordinates: LocationError.restricted)
        default:
            manager.startUpdatingLocation()
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.location(self, didReceiveCoordinates: Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
        manager.stopUpdatingLocation()
        self.manager?.delegate = nil
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.location(self, didFailToReceiveCoordinates: error)
        manager.stopUpdatingLocation()
        self.manager?.delegate = nil
    }
    
}
