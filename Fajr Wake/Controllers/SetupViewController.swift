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
    @IBOutlet private var wakeupTagLabel: UILabel!
    @IBOutlet private var minsAdjustLabel: UILabel!
    @IBOutlet private var onOffButton: UIButton!
    @IBOutlet private var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet private var closeBarButtonItem: UIBarButtonItem!
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - View Setup
    
    private func setupOnOffButton() {
        
    }

}

