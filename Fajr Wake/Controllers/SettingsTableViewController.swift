//
//  SettingsTableViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/18/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class SettingsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var placeLabel: UILabel!
    @IBOutlet private var soundDetailLabel: UILabel!
    @IBOutlet private var calculationMethodDetailLabel: UILabel!
    
    // MARK: - Other Properties
    
    private var alarm = Alarm.shared
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupOutlets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Viwes Setup
    
    private func setupOutlets() {
        setupSoundDetailLabel()
        calculationMethodDetailLabel.text = alarm.praytime.setting.calcMethod.description
        placeLabel.text = alarm.placeName
    }
    
    private func setupSoundDetailLabel() {
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
        let location = Location()
        location.fetchAndSaveLocationForAlarm {
            [weak self] (error) in
            guard self != nil else { return }
            if let error = error {
                // FIXME: - display error to user
                print(error.localizedDescription)
            } else {
                location.fetchAndStorePlaceName() {
                    self!.setupOutlets()
                }
                self!.setupOutlets()
            }
            MBProgressHUD.hide(for: self!.view, animated: true)
        }
    }
    
    // MARK: - TableView Setup
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 && indexPath.section == 0 {
            fetchLocation()
        }
    }
}
