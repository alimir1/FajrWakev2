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
    @IBOutlet private var wakeUpTimeLabel: UILabel!
    @IBOutlet private var onOffButton: UIButton!
    @IBOutlet private var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet private var closeBarButtonItem: UIBarButtonItem!
    
    // MARK: - Stored properties
    
    private var shouldReactivate = false // only used for UIPanGestureRecognizer
    
    // MARK: - Getters and setters
    
    private var alarmMode: Prayer {
        get {
            return Alarm.shared.selectedPrayer
        }
        set {
            Alarm.shared.setSelectedPrayer(newValue)
            self.updateOutlets()
            Alarm.shared.resetActiveAlarm {
                _ in
                // FIXME: Needs to warn user in case of error!
            }
        }
    }
    
   private var isAlarmOn: Bool {
        get {
            return Alarm.shared.status != .inActive
        }
        set {
            if newValue {
                Alarm.shared.turnOn { _ in
                    // FIXME: Needs to warn user in case of error!
                }
            } else {
                Alarm.shared.turnOff()
            }
            updateOutlets()
        }
    }
    
    private var minsToAdjust: Int {
        get {
            return Alarm.shared.adjustMins
        }
        
        set {
            Alarm.shared.setAdjustMins(newValue)
            updateTitleLabel()
            updateMinsToAdjustLabel()
            updateWakeupTimeLabel()
        }
    }
    
    // MARK: - Computed Properties
    
    private let dateFormatter: (time: DateFormatter, ampm: DateFormatter) = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm"
        let ampmFormatter = DateFormatter()
        ampmFormatter.dateFormat = "a"
        return (time: timeFormatter, ampm: ampmFormatter)
    }()
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOutlets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Views Setup
    
    private func updateOutlets() {
        segmentedControl.selectedSegmentIndex = alarmMode.rawValue
        updateTitleLabel()
        updateMinsToAdjustLabel()
        updateOnOffButton()
        updateWakeupTimeLabel()
    }
    
    private func updateWakeupTimeLabel() {
        let formatter = dateFormatter
        let ampm = formatter.ampm.string(from: Alarm.shared.alarmDateForCurrentSetting)
        let time = formatter.time.string(from: Alarm.shared.alarmDateForCurrentSetting)
        
        let combination = NSMutableAttributedString()
        let timeThing = NSMutableAttributedString(string: time)
        let amPmThing = NSMutableAttributedString(string: ampm)
        timeThing.addAttribute(.font, value: UIFont.systemFont(ofSize: 40.0), range: NSMakeRange(0, time.count))
        amPmThing.addAttribute(.font, value: UIFont.systemFont(ofSize: 20.0), range: NSMakeRange(0, ampm.count))
        combination.append(timeThing)
        combination.append(amPmThing)
        
        wakeUpTimeLabel.attributedText = combination
        
    }
    
    private func updateTitleLabel() {
        let wakeupTime = alarmMode.description
        if minsToAdjust == 0 {
            navigationItem.title = "At \(wakeupTime)"
        } else {
            navigationItem.title = Alarm.shared.description
        }
    }
    
    private func updateMinsToAdjustLabel() {
        if minsToAdjust == 0 {
            minsAdjustLabel.text = "At"
        } else {
            minsAdjustLabel.text = minsToAdjust > 0 ? "+\(minsToAdjust)" : "\(minsToAdjust)"
        }
    }
    
    private func updateOnOffButton() {
        onOffButton.backgroundColor = isAlarmOn ? .red : UIColor.brand.theme
        onOffButton.setTitle("\(isAlarmOn ? "Turn off" : "Turn on")", for: .normal)
    }
    
    // MARK: - Target-actions
    
    @IBAction private func onPanMinsLabel(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: minsAdjustLabel)
        let translation = sender.translation(in: minsAdjustLabel)
        guard abs(velocity.x) > abs(velocity.y) else { return }
        let incrementValue = velocity.x > 0 ? 1 : -1
        switch sender.state {
        case .began:
            if Alarm.shared.status == .activeAndNotFired {
                Alarm.shared.turnOff()
                shouldReactivate = true
            }
        case .changed:
            if (abs(velocity.x)) > 700 {
                updateMinsToAdjust(incrementValue: incrementValue)
            } else {
                if translation.x.truncatingRemainder(dividingBy: 3) == 0 {
                    updateMinsToAdjust(incrementValue: incrementValue)
                }
            }
        case .ended, .cancelled:
            if shouldReactivate {
                Alarm.shared.turnOn { _ in
                    // FIXME: Needs to warn user in case of error!
                }
                shouldReactivate = false
            }
        default: break
        }
    }
    
    @IBAction private func onSegmentChange(sender: Any) {
        alarmMode = Prayer(rawValue: segmentedControl.selectedSegmentIndex) ?? .fajr
    }
    
    @IBAction private func onToggleOnOff(sender: Any) {
        isAlarmOn = !isAlarmOn
    }
    
    @IBAction private func onDismiss(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsVC" {
            let settingsVC = segue.destination
            settingsVC.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - Helpers
    
    private func updateMinsToAdjust(incrementValue: Int) {
        minsToAdjust = abs(minsToAdjust + incrementValue) != 0 && abs(minsToAdjust + incrementValue) != 60 ? minsToAdjust + incrementValue : 0
    }
}

