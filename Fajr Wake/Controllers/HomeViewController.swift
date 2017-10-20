//
//  HomeViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var placeNameLabel: UILabel!
    @IBOutlet private var currentTimeLabel: UILabel!
    @IBOutlet private var alarmTimeLabel: UILabel!
    @IBOutlet private var alarmDescriptionLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    
    // MARK: - Stored Properties
    
    private var currentTimeUpdateTimer: Timer?
    
    // MARK: - Computed Properties
    
    private let dateFormatter: (time: DateFormatter, ampm: DateFormatter) = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm:ss"
        let ampmFormatter = DateFormatter()
        ampmFormatter.dateFormat = "a"
        return (time: timeFormatter, ampm: ampmFormatter)
    }()
    
    private let standardDateFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MM-dd-yyyy h:mm a"
//        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter
    }()
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOutlets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstAppLaunch {
            fetchLocation()
        }
        currentTimeUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTimeLabel), userInfo: nil, repeats: true)
    }
    
    // MARK: - Views Setup
    
    private func updateOutlets() {
        let alarm = Alarm.shared
        placeNameLabel.text = " \(alarm.placeName)"
        updateCurrentTimeLabel()
        messageLabel.text = alarm.statusMessage
        alarmDescriptionLabel.text = alarm.status != .inActive ? alarm.description : ""
        alarmTimeLabel.text = alarm.fireDate != nil ? " \(standardDateFormatter.string(from: alarm.fireDate!))" : " Setup Alarm"
    }
    
    @objc private func updateCurrentTimeLabel() {
        let curDate = Date()
        let formatter = dateFormatter
        let ampm = formatter.ampm.string(from: curDate)
        let time = formatter.time.string(from: curDate)
        currentTimeLabel.text = "\(time) \(ampm)"
        messageLabel.text = Alarm.shared.statusMessage
    }
    
    // MARK: - Helpers
    
    private func fetchLocation() {
        Alarm.shared.fetchLocation(withView: view, completionHandler: {self.updateOutlets()})
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToHomeVC(unwindSegue: UIStoryboardSegue) { }
    
}
