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
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOutlets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFirstLaunch()
    }
    
    func setupFirstLaunch() {
        if isFirstAppLaunch {
            let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
            welcomeVC.successHandler = {
                self.fetchLocation()
            }
            present(welcomeVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         currentTimeUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTimeLabel), userInfo: nil, repeats: true)
    }
    
    // MARK: - Views Setup
    
    private func updateOutlets() {
        let alarm = Alarm.shared
        placeNameLabel.text = " \(alarm.placeName)"
        updateCurrentTimeLabel()
        messageLabel.text = alarm.statusMessage
        alarmDescriptionLabel.text = alarm.status != .inActive ? alarm.description : ""
    }
    
    private func updateAlarmTimeLabel() {
        let alarm = Alarm.shared
        if let fireDate = alarm.fireDate {
            let dateString = fireDate.timeString
            alarmTimeLabel.text = Calendar.current.isDateInToday(fireDate) ? " Today at \(dateString)" : " Tomorrow at \(dateString)"
        } else {
            alarmTimeLabel.text = " Setup Alarm"
        }
    }
    
    @objc private func updateCurrentTimeLabel() {
        let formatter = DateFormatter.splitDateFormatter
        let time = formatter.time.string(from: Date())
        let amPM = " " + formatter.ampm.string(from: Date())
        let attributedStr = NSAttributedString.bigSmallFormattedString(biggerString: time, smallerString: amPM, biggerFontSize: 60, smallerFontSize: 30)
        currentTimeLabel.attributedText = attributedStr
        messageLabel.text = Alarm.shared.statusMessage
        updateAlarmTimeLabel()
    }
    
    // MARK: - Helpers
    
    private func fetchLocation() {
        Alarm.shared.fetchLocation(withView: view, completionHandler: {
            self.updateOutlets()
            Alarm.shared.resetActiveAlarm(completion: nil)
        })
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToHomeVC(unwindSegue: UIStoryboardSegue) { }
    
}
