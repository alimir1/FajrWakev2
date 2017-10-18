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
    
    var isAlarmOn: Bool = false
    var alarmMode: Prayer = .fajr
    
    // MARK: - Property Observers
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minsToAdjust = 0
    }
    
    // MARK: - View Setup
    
    private func setupTitleLabel() {
        let wakeupTime = Prayer(rawValue: segmentedControl.selectedSegmentIndex)?.description ?? ""
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
    }
    
    @IBAction private func onSegmentChange(sender: Any) {
        setupTitleLabel()
    }
    
    // MARK: - Helpers
    
    private func updateMinsToAdjust(incrementValue: Int) {
        minsToAdjust = abs(minsToAdjust + incrementValue) != 0 && abs(minsToAdjust + incrementValue) != 60 ? minsToAdjust + incrementValue : 0
    }
    
}

