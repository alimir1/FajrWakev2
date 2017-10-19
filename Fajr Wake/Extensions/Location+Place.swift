////
////  Alarm+Location.swift
////  Fajr Wake
////
////  Created by Ali Mir on 10/19/17.
////  Copyright © 2017 com.AliMir. All rights reserved.
////
//
//import Foundation
//
//extension Location {
//
//    internal func fetchLocation() {
//
//    }
//
//    internal func location(_ location: Location, didFailToReceiveCoordinates error: Error) {
//        print("Error! \n\(error)") // FIXME: Display error to user
//    }
//
//    internal func location(_ location: Location, didReceiveCoordinates coordinates: Coordinates) {
//
//        // Update coordinates
//
//        alarm.setCoordinates(coordinate: coordinates)
//        let latStr = String(format: "%0.2f", arguments: [coordinates.latitude])
//        let lngStr = String(format: "%0.2f", arguments: [coordinates.longitude])
//        alarm.setPlaceName("\(latStr), \(lngStr)")
//        setupOutlets()
//
//        // Update place name
//
//        location.lookUpCurrentLocationInfo { placeName in
//            if let name = placeName {
//                self.alarm.setPlaceName(name)
//                self.setupOutlets()
//            }
//        }
//
//    }
//}

