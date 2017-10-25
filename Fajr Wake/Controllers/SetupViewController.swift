//
//  ViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//



import UIKit
import HGCircularSlider

internal class SetupViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var prayerSegmentedControl: UISegmentedControl!
    @IBOutlet private var beforeAfterSegmentedControl: UISegmentedControl!
    @IBOutlet private var minsAdjustLabel: UILabel!
    @IBOutlet private var beforeAfterLabel: UILabel!
    @IBOutlet private var wakeUpTimeLabel: UILabel!
    @IBOutlet private var onOffButton: UIButton!
    @IBOutlet private var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet private var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet private var circularSliderView: UIView!
    
    // MARK: - Getters and setters
    
    private var alarmMode: Prayer {
        get {
            return Alarm.shared.selectedPrayer
        }
        set {
            Alarm.shared.setSelectedPrayer(newValue)
            self.updateOutlets()
            if Alarm.shared.status != .inActive {
                self.wakeUpTimeLabel.shake()
            }
            Alarm.shared.resetActiveAlarm {
                self.updateOutlets()
            }
        }
    }
    
   private var isAlarmOn: Bool {
        get {
            return Alarm.shared.status != .inActive
        }
        set {
            if newValue {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                Alarm.shared.turnOn {
                    self.updateOutlets()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            } else {
                Alarm.shared.turnOff()
                updateOutlets()
            }
        }
    }
    
    private var minsToAdjust: Int {
        get {
            return Alarm.shared.adjustMins
        }
        set {
            Alarm.shared.setAdjustMins(newValue)
            updateOutlets()
        }
    }
    
    // MARK: - Computed Properties
    
    private let dateFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter
    }()
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOutlets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onOffButton.layer.masksToBounds = true
        onOffButton.layer.cornerRadius = 10
        if let circularView = circularSliderView as? CircularSlider {
            circularView.addTarget(self, action: #selector(onCircularSliderValueChange), for: .valueChanged)
        }
    }
    
    // MARK: - Views Setup
    
    private func updateOutlets() {
        prayerSegmentedControl.selectedSegmentIndex = alarmMode.rawValue
        beforeAfterSegmentedControl.selectedSegmentIndex = minsToAdjust < 0 ? 0 : 1
        beforeAfterSegmentedControl.isEnabled = minsToAdjust != 0
        if let circularSlider = circularSliderView as? CircularSlider {
            circularSlider.endPointValue = CGFloat(abs(minsToAdjust))
        }
        updateMinsToAdjustLabel()
        updateOnOffButton()
        updateWakeupTimeLabel()
        updateBeforeAfterLabel()
    }
    
    private func updateWakeupTimeLabel() {
        let calculatedAlarmDate = Alarm.shared.alarmDateForCurrentSetting
        let timeStr = dateFormatter.string(from: calculatedAlarmDate)
        wakeUpTimeLabel.text = " Alarm at \(timeStr)"
    }
    
    private func updateMinsToAdjustLabel() {
        guard self.minsToAdjust != 0 else {
            minsAdjustLabel.text = "At"
            return
        }
        let minStr = "min"
        let adjustMinStr = "\(abs(minsToAdjust))"
        let combination = NSMutableAttributedString()
        let adjustMins = NSMutableAttributedString(string: adjustMinStr)
        let min = NSMutableAttributedString(string: minStr)
        adjustMins.addAttribute(.font, value: UIFont.systemFont(ofSize: 60.0), range: NSMakeRange(0, adjustMinStr.count))
        min.addAttribute(.font, value: UIFont.systemFont(ofSize: 30.0), range: NSMakeRange(0, minStr.count))
        combination.append(adjustMins)
        combination.append(min)
        minsAdjustLabel.attributedText = combination
    }
    
    private func updateBeforeAfterLabel() {
        if minsToAdjust == 0 {
            beforeAfterLabel.text = alarmMode.description.capitalized
            return
        }
        beforeAfterLabel.text = minsToAdjust < 0 ? "Before \(alarmMode.description.capitalized)" : "After \(alarmMode.description.capitalized)"
    }
    
    private func updateOnOffButton() {
        onOffButton.backgroundColor = isAlarmOn ? .red : UIColor.brand.theme
        onOffButton.setTitle("\(isAlarmOn ? "Turn off" : "Turn on")", for: .normal)
    }
    
    // MARK: - Target-actions
    
    @objc private func onCircularSliderValueChange(_ sender: CircularSlider) {
        if Alarm.shared.status != .inActive {
            Alarm.shared.turnOff()
            onOffButton.shake()
        }
        minsToAdjust = beforeAfterSegmentedControl.selectedSegmentIndex == 0 ? -Int(sender.endPointValue) : abs(Int(sender.endPointValue))
    }
    
    @IBAction private func onPrayerSegmentChange(sender: UISegmentedControl) {
        alarmMode = Prayer(rawValue: prayerSegmentedControl.selectedSegmentIndex) ?? .fajr
    }
    
    @IBAction private func onToggleOnOff(sender: Any) {
        isAlarmOn = !isAlarmOn
    }
    
    @IBAction private func onDismiss(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func onBeforeAfterSegmentedChange(sender: UISegmentedControl) {
        minsToAdjust = sender.selectedSegmentIndex == 0 ? -minsToAdjust : abs(minsToAdjust)
        if Alarm.shared.status != .inActive {
            self.wakeUpTimeLabel.shake()
        }
        Alarm.shared.resetActiveAlarm {
            self.updateOutlets()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsVC" {
            let settingsVC = segue.destination
            settingsVC.navigationItem.rightBarButtonItem = nil
        }
    }
}

