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
        
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            return UIViewController.topViewController(with: rootVC)
        } else {
            return nil
        }
    }
    
    private class func topViewController(with viewController: UIViewController) -> UIViewController? {
        if viewController is UITabBarController{
            if let tabBarController = viewController as? UITabBarController, let selectedVC = tabBarController.selectedViewController {
                return topViewController(with: selectedVC)
            }
        }
        if viewController is UINavigationController{
            if let navBarController = viewController as? UINavigationController, let visibleVC = navBarController.visibleViewController {
                return topViewController(with: visibleVC)
            }
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
