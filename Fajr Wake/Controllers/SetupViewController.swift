//
//  ViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//



import UIKit

internal class SetupViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var minsAdjustLabel: UILabel!
    @IBOutlet private var onOffButton: UIButton!
    @IBOutlet private var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet private var closeBarButtonItem: UIBarButtonItem!
    
    // MARK: - Stored properties
    
    var alarmMode: Prayer = .fajr {
        didSet {
            setupTitleLabel()
            segmentedControl.selectedSegmentIndex = alarmMode.rawValue
        }
    }
    
    // MARK: - Property Observers
    
    var isAlarmOn: Bool = false {
        didSet {
            onOffButton.backgroundColor = isAlarmOn ? .red : UIColor.brand.theme
            onOffButton.setTitle("\(isAlarmOn ? "Turn off" : "Turn on")", for: .normal)
        }
    }
    
    var minsToAdjust: Int = 0 {
        didSet {
            if minsToAdjust == 0 {
                minsAdjustLabel.text = "At"
            } else {
                minsAdjustLabel.text = minsToAdjust > 0 ? "+\(minsToAdjust)" : "\(minsToAdjust)"
            }
            setupTitleLabel()
        }
    }
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        minsToAdjust = 0
        isAlarmOn = false
        alarmMode = .fajr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Views Setup
    
    private func setupTitleLabel() {
        let wakeupTime = alarmMode.description
        if minsToAdjust == 0 {
            navigationItem.title = "At \(wakeupTime)"
        } else {
            navigationItem.title = "\(abs(minsToAdjust)) mins \(minsToAdjust > 0 ? "after" : "before") \(wakeupTime)"
        }
    }
    
    // MARK: - Target-actions
    
    @IBAction private func onPanMinsLabel(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: minsAdjustLabel)
        let translation = sender.translation(in: minsAdjustLabel)
        guard abs(velocity.x) > abs(velocity.y) else { return }
        let incrementValue = velocity.x > 0 ? 1 : -1
        if (abs(velocity.x)) > 700 {
            updateMinsToAdjust(incrementValue: incrementValue)
        } else {
            if translation.x.truncatingRemainder(dividingBy: 3) == 0 {
                updateMinsToAdjust(incrementValue: incrementValue)
            }
        }
        turnOffAndReConfigureAlarm()
    }
    
    @IBAction private func onSegmentChange(sender: Any) {
        alarmMode = Prayer(rawValue: segmentedControl.selectedSegmentIndex) ?? .fajr
        turnOffAndReConfigureAlarm()
    }
    
    @IBAction private func onToggleOnOff(sender: Any) {
        isAlarmOn = !isAlarmOn
    }
    
    @IBAction private func onDismiss(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func updateMinsToAdjust(incrementValue: Int) {
        minsToAdjust = abs(minsToAdjust + incrementValue) != 0 && abs(minsToAdjust + incrementValue) != 60 ? minsToAdjust + incrementValue : 0
    }
    
    private func turnOffAndReConfigureAlarm() {
        
    }
    
}

