//
//  SettingsTableViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/18/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class SettingsTableViewController: UITableViewController, LocationDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private var placeLabel: UILabel!
    @IBOutlet private var soundDetailLabel: UILabel!
    @IBOutlet private var calculationMethodDetailLabel: UILabel!
    
    // MARK: - Other Properties
    
    private var alarm = Alarm.shared
    private var location: Location!
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupOutlets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Viwes Setup
    
    func setupOutlets() {
        setupSoundDetailLabel()
        calculationMethodDetailLabel.text = alarm.praytime.setting.calcMethod.description
        placeLabel.text = alarm.placeName
    }
    
    func setupSoundDetailLabel() {
        for ringtone in Ringtones.data {
            if let soundInfo = ringtone["fileName"], soundInfo == alarm.soundPlayer.setting.ringtoneID {
                soundDetailLabel.text = ringtone["title"]
                return
            }
        }
        soundDetailLabel.text = ""
    }
    
    // MARK: - Helpers
    
    private func fetchLocation() {
        MBProgressHUD.showAdded(to: view, animated: true)
        location = Location(delegate: self)
        location.fetchUserLocation()
    }
    
    // MARK: - Location Delegate
    
    func location(_ location: Location, didFailToReceiveCoordinates error: Error) {
        print("Error! \n\(error)") // FIXME: Display error to user
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func location(_ location: Location, didReceiveCoordinates coordinates: Coordinates) {
        
        // Update coordinates
        
        alarm.setCoordinates(coordinate: coordinates)
        let latStr = String(format: "%0.2f", arguments: [coordinates.latitude])
        let lngStr = String(format: "%0.2f", arguments: [coordinates.longitude])
        alarm.setPlaceName("\(latStr), \(lngStr)")
        setupOutlets()
        
        // Update place name
        
        location.lookUpCurrentLocationInfo { placeName in
            if let name = placeName {
                self.alarm.setPlaceName(name)
                self.setupOutlets()
            }
        }
        
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    // MARK: - TableView Setup
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 && indexPath.section == 0 {
            fetchLocation()
        }
        
    }
    
}
