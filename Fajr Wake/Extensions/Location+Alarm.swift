//
//  Location+Place.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/19/17.
//  Copyright © 2017 com.AliMir. All rights reserved.

extension Location {
    internal func fetchAndSaveLocationForAlarm(completion: @escaping (_ error: Error?) -> Void) {
        fetchUserLocation()
        coordinateCompletion = { (coordinate, error) in
            if let coordinate = coordinate {
                completion(nil)
                Alarm.shared.setCoordinate(coordinate: coordinate)
            } else {
                completion(error)
            }
        }
    }
    
    internal func fetchAndStorePlaceName(completion: (() -> Void)?) {
        lookUpCurrentLocationInfo() {
            (placeName) in
            if let placeName = placeName {
                Alarm.shared.setPlaceName(placeName)
            } else {
                if let latestCoordinate = self.latestLocation?.coordinate {
                    let latStr = String(format: "%0.2f", arguments: [latestCoordinate.latitude])
                    let lngStr = String(format: "%0.2f", arguments: [latestCoordinate.longitude])
                    Alarm.shared.setPlaceName("\(latStr), \(lngStr)")
                    completion?()
                }
            }
            completion?()
        }
    }
}

