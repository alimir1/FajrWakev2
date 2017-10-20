//
//  UIViewController+TopViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/19/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

extension UIViewController {
    
    public class var topViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController != nil ? UIViewController.topViewController(with: UIApplication.shared.keyWindow!.rootViewController!) : nil
    }
    
    private class func topViewController(with viewController: UIViewController) -> UIViewController {
        if viewController is UITabBarController{
            let tabBarController = viewController as! UITabBarController
            return topViewController(with: tabBarController.selectedViewController!)
        }
        if viewController is UINavigationController{
            let navBarController = viewController as! UINavigationController
            return topViewController(with: navBarController.visibleViewController!)
        }
        if let presentedViewController = viewController.presentedViewController {
            return topViewController(with: presentedViewController)
        }
        return viewController
    }
    
    public var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
    
}
