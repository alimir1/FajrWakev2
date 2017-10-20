//
//  Alarm+Location.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/19/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

extension Alarm {
    internal func fetchLocation(withView: UIView, completionHandler: (()->Void)?) {
        MBProgressHUD.showAdded(to: withView, animated: true)
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
                    completionHandler?()
                }
                _ = SweetAlert().showAlert("Success!", subTitle: "Location has been successfully updated.", style: AlertStyle.success)
                completionHandler?()
            }
            MBProgressHUD.hide(for: withView, animated: true)
        }
    }
}
