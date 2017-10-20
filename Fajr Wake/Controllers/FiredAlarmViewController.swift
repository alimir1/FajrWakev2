//
//  FiredAlarmViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/19/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class FiredAlarmViewController: UIViewController {

    @IBOutlet private var alarmDescriptionLabel: UILabel!
    @IBOutlet private var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmDescriptionLabel.text = "It's \(Alarm.shared.description)!"
        dismissButton.layer.masksToBounds = true
        dismissButton.layer.cornerRadius = 10
    }
    
    @IBAction private func onDismissVC(sender: Any) {
        Alarm.shared.turnOff()
        dismiss(animated: true, completion: nil)
    }

}
