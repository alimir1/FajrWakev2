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
    
    @IBOutlet private var currentTimeLabel: UILabel!
    @IBOutlet private var alarmTimeLabel: UILabel!
    @IBOutlet private var alarmDescriptionLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var stopButton: UIButton!
    
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
        setupOutlets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTimeUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupCurrentTimeLabel), userInfo: nil, repeats: true)
    }
    
    // MARK: - Views Setup
    
    private func setupOutlets() {
        let alarm = Alarm.shared
        setupCurrentTimeLabel()
        messageLabel.text = alarm.statusMessage
        alarmDescriptionLabel.text = alarm.status != .inActive ? alarm.description : ""
        alarmTimeLabel.text = alarm.fireDate != nil ? " \(standardDateFormatter.string(from: alarm.fireDate!))" : " Setup Alarm"
        stopButton.isHidden = alarm.status != .activeAndFired
    }
    
    @objc private func setupCurrentTimeLabel() {
        let curDate = Date()
        let formatter = dateFormatter
        let ampm = formatter.ampm.string(from: curDate)
        let time = formatter.time.string(from: curDate)
        currentTimeLabel.text = "\(time) \(ampm)"
        messageLabel.text = Alarm.shared.statusMessage
    }
    
}
