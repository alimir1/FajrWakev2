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
            (error) in
            if let error = error {
                print(error.localizedDescription)
                let error = error as NSError
                let title = error.localizedDescription
                let subTitle = "\(String(describing: error.localizedFailureReason ?? "")) \(String(describing: error.localizedRecoverySuggestion ?? ""))"
                let cancelButtonColor = UIColor(red: 0.7333, green: 0.8078, blue: 0.8078, alpha: 1.0)
                let settingsButtonColor = UIColor(red: 0.7882, green: 0.2824, blue: 0.2824, alpha: 1.0)
                let settingsURL = URL(string: "App-Prefs:root")
                SweetAlert().showAlert(title, subTitle: subTitle, style: AlertStyle.error, buttonTitle:"Cancel", buttonColor: cancelButtonColor, otherButtonTitle:  "Settings", otherButtonColor: settingsButtonColor) { isOtherButton in
                    if !isOtherButton {
                        if let url = settingsURL {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            } else {
                location.fetchAndStorePlaceName() {
                    self.setupOutlets()
                }
                _ = SweetAlert().showAlert("Success!", subTitle: "Location has been successfully updated.", style: AlertStyle.success)
                self.setupOutlets()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
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
