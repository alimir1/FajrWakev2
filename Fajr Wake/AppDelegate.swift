//
//  AppDelegate.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        if Alarm.setupForBeginningState(shouldPresentAlarmVC: false) {
            presentFiredAlarmVC()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
        Alarm.shared.invalidateTimer()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        _ = Alarm.setupForBeginningState()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    
    
    func presentFiredAlarmVC() {
        let fireAlarmVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firedAlarmVC") as! FiredAlarmViewController
        fireAlarmVC.dismissedCompletion = {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeViewController")
        }
        window?.rootViewController = fireAlarmVC
    }
}


